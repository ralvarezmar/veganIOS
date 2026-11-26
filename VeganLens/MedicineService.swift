import Foundation

enum MedicineFetchResult: Equatable {
    case success(MedicineInfo, fromCache: Bool)
    case notFound([MedicineSource])
    case error(String)
}

enum MedicineSearchResult: Equatable {
    case success([MedicineSearchItem])
    case partial([MedicineSearchItem], unavailable: MedicineSource)
    case empty
    case offline
    case unavailable
}

struct MedicineService {
    static let searchLimit = 15

    static let cimaBaseURL = "https://cima.aemps.es/cima/rest"
    static let openFDABaseURL = "https://api.fda.gov"

    private let session: URLSession
    private let defaults: UserDefaults

    init(session: URLSession = OpenFactsService.defaultSession, defaults: UserDefaults = .standard) {
        self.session = session
        self.defaults = defaults
    }

    static func cacheKey(for barcode: String) -> String {
        "medicine_cache_\(barcode)"
    }

    static func cimaURL(nationalCode: String) -> URL? {
        URL(string: "\(cimaBaseURL)/medicamento?cn=\(nationalCode)")
    }

    static func openFDAURL(upc: String, ndcCandidates: [String]) -> URL? {
        openFDAURL(terms: ["openfda.upc:\"\(upc)\""] + ndcCandidates.map { "openfda.package_ndc:\"\($0)\"" }, limit: 1)
    }

    static func cimaURL(nregistro: String) -> URL? {
        URL(string: "\(cimaBaseURL)/medicamento?nregistro=\(nregistro)")
    }

    static func openFDAURL(setId: String) -> URL? {
        openFDAURL(terms: ["set_id:\"\(setId)\""], limit: 1)
    }

    static func cimaSearchURL(query: String) -> URL? {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { return nil }
        return URL(string: "\(cimaBaseURL)/medicamentos?nombre=\(encoded)&comerc=1")
    }

    static func openFDASearchURL(query: String) -> URL? {
        let phrase = query.replacingOccurrences(of: "\"", with: "")
        return openFDAURL(terms: ["openfda.brand_name:\"\(phrase)\"", "openfda.generic_name:\"\(phrase)\""], limit: searchLimit)
    }

    private static func openFDAURL(terms: [String], limit: Int) -> URL? {
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "-._:")
        let encoded = terms.compactMap { $0.addingPercentEncoding(withAllowedCharacters: allowed) }
        return URL(string: "\(openFDABaseURL)/drug/label.json?search=\(encoded.joined(separator: "+OR+"))&limit=\(limit)")
    }

    /// Searches CIMA and openFDA by medicine name; one source failing still returns the other's results.
    func searchByName(query: String) async -> MedicineSearchResult {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              let cimaURL = Self.cimaSearchURL(query: trimmed),
              let fdaURL = Self.openFDASearchURL(query: trimmed) else { return .empty }
        async let cima = searchItems(cimaURL) { (response: CimaSearchResponse) in
            (response.resultados ?? []).compactMap { $0.toSearchItem() }
        }
        async let fda = searchItems(fdaURL) { (response: OpenFDALabelResponse) in
            (response.results ?? []).compactMap { $0.toSearchItem() }
        }
        let cimaResult = await cima
        let fdaResult = await fda
        let results = [cimaResult, fdaResult]
        var seen = Set<String>()
        let items = Array(
            results
                .flatMap { (try? $0.get()) ?? [] }
                .filter { seen.insert($0.code).inserted }
                .prefix(Self.searchLimit * 2)
        )
        let cimaFailed = (try? cimaResult.get()) == nil
        let fdaFailed = (try? fdaResult.get()) == nil
        switch (cimaFailed, fdaFailed) {
        case (true, true):
            let offline = results.allSatisfy { result in
                guard case .failure(let error) = result else { return false }
                return Self.isOfflineError(error)
            }
            return offline ? .offline : .unavailable
        case (true, false):
            return .partial(items, unavailable: .cima)
        case (false, true):
            return .partial(items, unavailable: .openFDA)
        case (false, false):
            return items.isEmpty ? .empty : .success(items)
        }
    }

    private static func isOfflineError(_ error: Error) -> Bool {
        guard let urlError = error as? URLError else { return false }
        return [.notConnectedToInternet, .networkConnectionLost, .dataNotAllowed, .internationalRoamingOff]
            .contains(urlError.code)
    }

    private struct SearchSourceUnavailable: Error {}

    private func searchItems<T: Decodable>(
        _ url: URL,
        _ map: @escaping (T) -> [MedicineSearchItem]
    ) async -> Result<[MedicineSearchItem], Error> {
        do {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw SearchSourceUnavailable() }
            if http.statusCode == 404 || http.statusCode == 204 { return .success([]) }
            guard (200..<300).contains(http.statusCode), !data.isEmpty else { throw SearchSourceUnavailable() }
            return .success(map(try JSONDecoder().decode(T.self, from: data)))
        } catch {
            return .failure(error)
        }
    }

    func fetchMedicine(barcode: String) async -> MedicineFetchResult {
        guard let code = medicineCode(for: barcode) else {
            return .notFound([])
        }
        do {
            let result: MedicineFetchResult
            switch code {
            case .spanishNational(let nationalCode):
                result = try await fetchCima(barcode: barcode, nationalCode: nationalCode)
            case .usNDC(let upc, let candidates):
                result = try await fetchOpenFDA(barcode: barcode, upc: upc, ndcCandidates: candidates)
            case .cimaRegistration(let nregistro):
                result = try await fetchCima(barcode: barcode, url: Self.cimaURL(nregistro: nregistro))
            case .openFDASetId(let setId):
                result = try await fetchOpenFDA(barcode: barcode, url: Self.openFDAURL(setId: setId))
            }
            if case .success(let medicine, _) = result {
                writeCache(medicine, barcode: barcode)
            }
            return result
        } catch {
            if let cached = cachedMedicine(barcode: barcode) {
                return .success(cached, fromCache: true)
            }
            return .error(error.localizedDescription)
        }
    }

    func cachedMedicine(barcode: String) -> MedicineInfo? {
        guard let data = defaults.data(forKey: Self.cacheKey(for: barcode)) else { return nil }
        return try? JSONDecoder().decode(MedicineInfo.self, from: data)
    }

    private func writeCache(_ medicine: MedicineInfo, barcode: String) {
        guard let data = try? JSONEncoder().encode(medicine) else { return }
        defaults.set(data, forKey: Self.cacheKey(for: barcode))
    }

    private func fetchCima(barcode: String, nationalCode: String) async throws -> MedicineFetchResult {
        try await fetchCima(barcode: barcode, url: Self.cimaURL(nationalCode: nationalCode))
    }

    private func fetchCima(barcode: String, url: URL?) async throws -> MedicineFetchResult {
        guard let url else { return .notFound([.cima]) }
        let medicine: CimaMedicamento? = try await decode(url)
        guard let info = medicine?.toMedicineInfo(code: barcode) else { return .notFound([.cima]) }
        return .success(info, fromCache: false)
    }

    private func fetchOpenFDA(barcode: String, upc: String, ndcCandidates: [String]) async throws -> MedicineFetchResult {
        try await fetchOpenFDA(barcode: barcode, url: Self.openFDAURL(upc: upc, ndcCandidates: ndcCandidates))
    }

    private func fetchOpenFDA(barcode: String, url: URL?) async throws -> MedicineFetchResult {
        guard let url else { return .notFound([.openFDA]) }
        let response: OpenFDALabelResponse? = try await decode(url)
        guard let info = response?.results?.first?.toMedicineInfo(code: barcode) else { return .notFound([.openFDA]) }
        return .success(info, fromCache: false)
    }

    /// Returns nil for HTTP errors or empty bodies (treated as "not found"); throws on transport errors.
    private func decode<T: Decodable>(_ url: URL) async throws -> T? {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode), !data.isEmpty else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
