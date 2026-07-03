import Foundation

struct FetchedProduct {
    let product: Product
    let source: ProductSource
}

enum OpenFactsFetchResult {
    case success(FetchedProduct)
    case notFound([ProductSource])
    case error(String)
}

final class OpenFactsService {
    private let session: URLSession
    private let userAgent = "VeganChecker-iOS/1.0"

    private static let fields = "product_name,brands,image_url,ingredients_text,ingredients_analysis_tags,ingredients,additives_tags,allergens_tags,nutriments,nutriscore_grade,quantity"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchProduct(barcode: String) async -> OpenFactsFetchResult {
        var sawCleanNoData = false
        var sawFailure = false
        var consultedSources: [ProductSource] = []

        for source in ProductSource.allCases {
            switch await fetchFromSource(source, barcode: barcode) {
            case .success(let product):
                return .success(FetchedProduct(product: product, source: source))
            case .cleanNoData:
                sawCleanNoData = true
                consultedSources.append(source)
            case .notFound:
                sawCleanNoData = true
                consultedSources.append(source)
            case .failure:
                sawFailure = true
            }
        }

        if sawCleanNoData {
            return .notFound(consultedSources)
        }
        if sawFailure {
            return .error("Sin conexión / error de red")
        }
        return .notFound(consultedSources)
    }

    private enum SourceFetchResult {
        case success(Product)
        case notFound
        case cleanNoData
        case failure
    }

    private func fetchFromSource(_ source: ProductSource, barcode: String) async -> SourceFetchResult {
        var components = URLComponents(url: source.baseURL, resolvingAgainstBaseURL: false)
        components?.path = "/api/v2/product/\(barcode).json"
        components?.queryItems = [URLQueryItem(name: "fields", value: Self.fields)]

        guard let url = components?.url else {
            return .failure
        }

        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return .failure
            }

            let decoded = try JSONDecoder().decode(OpenFactsResponse.self, from: data)

            if decoded.status == 1, let product = decoded.product, product.hasUsefulData {
                return .success(product)
            }

            if decoded.status == 1, decoded.product != nil {
                return .cleanNoData
            }

            if decoded.status == 0 {
                return .notFound
            }

            return .cleanNoData
        } catch {
            return .failure
        }
    }
}
