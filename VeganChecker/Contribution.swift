import Foundation
import Network
import UIKit

struct ContributionFormData: Equatable {
    var productName = ""
    var brands = ""
    var quantity = ""
    var categories = ""
    var ingredientsText = ""
    var labels = ""

    func fields(code: String) -> [String: String] {
        var result = ["code": code.trimmingCharacters(in: .whitespacesAndNewlines)]
        [
            ("product_name", productName),
            ("brands", brands),
            ("quantity", quantity),
            ("categories", categories),
            ("ingredients_text", ingredientsText),
            ("labels", labels)
        ].forEach { key, value in
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                result[key] = trimmed
            }
        }
        return result
    }
}

func contributionFormData(from product: Product) -> ContributionFormData {
    ContributionFormData(
        productName: product.productName ?? "",
        brands: product.brands ?? "",
        quantity: product.quantity ?? "",
        categories: (product.categoriesTags ?? []).map(cleanContributionTag).joined(separator: ", "),
        ingredientsText: product.ingredientsText ?? "",
        labels: (product.labelsTags ?? []).map(cleanContributionTag).joined(separator: ", ")
    )
}

private func cleanContributionTag(_ value: String) -> String {
    value.components(separatedBy: ":").last?.replacingOccurrences(of: "_", with: " ") ?? value
}

enum ProductContributionSource: String, CaseIterable, Identifiable {
    case openFoodFacts
    case openBeautyFacts
    case openProductFacts
    case openPetFoodFacts

    var id: String { rawValue }

    init(_ source: ProductSource) {
        self = ProductContributionSource(rawValue: source.rawValue) ?? .openFoodFacts
    }

    var productSource: ProductSource {
        ProductSource(rawValue: rawValue) ?? .openFoodFacts
    }

    var displayName: String { productSource.displayName }
}

func contributionURL(for source: ProductSource) -> URL {
    source.baseURL.appendingPathComponent("cgi/product_jqm2.pl")
}

enum ContributionResult: Equatable {
    case success
    case offline
    case networkError
    case serverError
}

enum ProductImageType: String, CaseIterable, Identifiable {
    case front
    case ingredients
    case nutrition
    case packaging

    var id: String { rawValue }
}

func imageField(for type: ProductImageType, locale: Locale = .current) -> String {
    let code = locale.languageCode ?? "es"
    let language = ["en", "es", "de", "fr"].contains(code) ? code : "es"
    return "\(type.rawValue)_\(language)"
}

func supportedProductLanguage(_ language: String) -> String {
    let normalized = language
        .lowercased()
        .split(whereSeparator: { $0 == "-" || $0 == "_" })
        .first
        .map(String.init) ?? "en"
    return ["es", "en", "de", "fr"].contains(normalized) ? normalized : "en"
}

func configuredProductLanguage() -> String {
    let identifier = Locale.preferredLanguages.first ?? Locale.current.identifier
    return supportedProductLanguage(identifier)
}

func anonymousImageFields(code: String, imageField: String) -> [String: String] {
    [
        "code": code.trimmingCharacters(in: .whitespacesAndNewlines),
        "imagefield": imageField
    ]
}

func productImageUploadURL(for source: ProductSource) -> URL {
    source.baseURL.appendingPathComponent("cgi/product_image_upload.pl")
}

struct ProductImageUploadSuccess: Equatable {
    let imageID: String?
    let imageField: String
}

enum ProductImageUploadResult: Equatable {
    case success(ProductImageUploadSuccess)
    case offline
    case networkError
    case serverError
}

final class ContributionService {
    private let session: URLSession
    private let monitor: NWPathMonitor
    private let monitorQueue = DispatchQueue(label: "veganchecker.contribution.network")
    private var isNetworkAvailable = true

    init(session: URLSession = .shared) {
        self.session = session
        self.monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isNetworkAvailable = path.status != .unsatisfied
        }
        monitor.start(queue: monitorQueue)
    }

    deinit {
        monitor.cancel()
    }

    func contribute(
        barcode: String,
        source: ProductSource,
        form: ContributionFormData
    ) async -> ContributionResult {
        guard isNetworkAvailable else { return .offline }
        var request = URLRequest(url: contributionURL(for: source))
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("VeganLens-iOS/1.0", forHTTPHeaderField: "User-Agent")
        request.httpBody = formURLEncoded(form.fields(code: barcode))

        do {
            let (data, response) = try await session.data(for: request)
            guard let status = response as? HTTPURLResponse else { return .networkError }
            guard (200..<300).contains(status.statusCode) else { return .serverError }
            return jsonStatus(from: data) == 1 ? .success : .serverError
        } catch {
            return .networkError
        }
    }

    func uploadImage(
        barcode: String,
        source: ProductSource,
        type: ProductImageType,
        jpegData: Data,
        locale: Locale = .current
    ) async -> ProductImageUploadResult {
        guard isNetworkAvailable else { return .offline }
        let field = imageField(for: type, locale: locale)
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: productImageUploadURL(for: source))
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("VeganLens-iOS/1.0", forHTTPHeaderField: "User-Agent")
        request.httpBody = multipartBody(
            fields: anonymousImageFields(code: barcode, imageField: field),
            fileName: "product-\(field).jpg",
            partName: "imgupload_\(field)",
            data: jpegData,
            boundary: boundary
        )

        do {
            let (data, response) = try await session.data(for: request)
            guard let status = response as? HTTPURLResponse else { return .networkError }
            guard (200..<300).contains(status.statusCode) else { return .serverError }
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  (json["status"] as? NSNumber)?.intValue == 1 else {
                return .serverError
            }
            return .success(ProductImageUploadSuccess(
                imageID: json["imgid"] as? String,
                imageField: json["imagefield"] as? String ?? field
            ))
        } catch {
            return .networkError
        }
    }
}

private func formURLEncoded(_ fields: [String: String]) -> Data? {
    var components = URLComponents()
    components.queryItems = fields.keys.sorted().map {
        URLQueryItem(name: $0, value: fields[$0] ?? "")
    }
    return components.percentEncodedQuery?.data(using: .utf8)
}

private func jsonStatus(from data: Data) -> Int? {
    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
    return (json["status"] as? NSNumber)?.intValue
}

private func multipartBody(
    fields: [String: String],
    fileName: String,
    partName: String,
    data: Data,
    boundary: String
) -> Data {
    var body = Data()
    for (name, value) in fields {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"\(partName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(data)
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    return body
}

func compressedJPEGData(_ image: UIImage, maxDimension: CGFloat = 1600) -> Data? {
    let largest = max(image.size.width, image.size.height)
    let scale = largest > maxDimension ? maxDimension / largest : 1
    let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
    let renderer = UIGraphicsImageRenderer(size: size)
    let rendered = renderer.image { _ in
        image.draw(in: CGRect(origin: .zero, size: size))
    }
    return rendered.jpegData(compressionQuality: 0.85)
}
