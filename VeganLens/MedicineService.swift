import Foundation

enum MedicineFetchResult: Equatable {
    case success(MedicineInfo, fromCache: Bool)
    case notFound([MedicineSource])
    case error(String)
}

struct MedicineService {
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
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "-._:")
        let terms = (["openfda.upc:\"\(upc)\""] + ndcCandidates.map { "openfda.package_ndc:\"\($0)\"" })
            .compactMap { $0.addingPercentEncoding(withAllowedCharacters: allowed) }
        return URL(string: "\(openFDABaseURL)/drug/label.json?search=\(terms.joined(separator: "+OR+"))&limit=1")
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
        guard let url = Self.cimaURL(nationalCode: nationalCode) else { return .notFound([.cima]) }
        let medicine: CimaMedicamento? = try await decode(url)
        guard let info = medicine?.toMedicineInfo(code: barcode) else { return .notFound([.cima]) }
        return .success(info, fromCache: false)
    }

    private func fetchOpenFDA(barcode: String, upc: String, ndcCandidates: [String]) async throws -> MedicineFetchResult {
        guard let url = Self.openFDAURL(upc: upc, ndcCandidates: ndcCandidates) else { return .notFound([.openFDA]) }
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
