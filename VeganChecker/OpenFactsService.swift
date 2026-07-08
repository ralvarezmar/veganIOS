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

enum SearchByNameResult {
    case success([OpenFoodFactsSearchProduct])
    case empty
    case error(String)
}

final class OpenFactsService {
    private let session: URLSession
    private let userAgent = "VeganLens-iOS/1.0"

    private static let fields = "product_name,brands,image_url,ingredients_text,ingredients_analysis_tags,ingredients,additives_tags,allergens_tags,nutriments,nutriscore_grade,ecoscore_grade,nova_group,quantity,carbohydrates_100g"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchProduct(barcode: String) async -> OpenFactsFetchResult {
        var sawCleanNoData = false
        var sawFailure = false
        var consultedSources: [ProductSource] = []
        var fallbackCandidate: FetchedProduct?

        for source in ProductSource.allCases {
            switch await fetchFromSource(source, barcode: barcode) {
            case .success(let product):
                if product.hasVeganData {
                    return .success(FetchedProduct(product: product, source: source))
                }
                if fallbackCandidate == nil {
                    fallbackCandidate = FetchedProduct(product: product, source: source)
                }
                consultedSources.append(source)
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

        if let fallbackCandidate {
            return .success(fallbackCandidate)
        }
        if sawCleanNoData {
            return .notFound(consultedSources)
        }
        if sawFailure {
            return .error(L("network_error"))
        }
        return .notFound(consultedSources)
    }

    func searchByName(query: String) async -> SearchByNameResult {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return .empty
        }

        guard let url = searchURL(for: trimmedQuery) else {
            return .error(L("network_error"))
        }

        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .error(L("network_error"))
            }

            if httpResponse.statusCode == 404 {
                return .empty
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                return .error(L("network_error"))
            }

            let decoded = try JSONDecoder().decode(OpenFoodFactsSearchResponse.self, from: data)
            let products: [OpenFoodFactsSearchProduct] = (decoded.products ?? []).compactMap { product -> OpenFoodFactsSearchProduct? in
                let code = product.code?.trimmingCharacters(in: .whitespacesAndNewlines)
                guard let code, !code.isEmpty else {
                    return nil
                }
                return OpenFoodFactsSearchProduct(
                    code: code,
                    productName: product.productName?.trimmingCharacters(in: .whitespacesAndNewlines).takeIfNotEmpty,
                    brands: product.brands?.trimmingCharacters(in: .whitespacesAndNewlines).takeIfNotEmpty,
                    imageUrl: product.imageUrl?.trimmingCharacters(in: .whitespacesAndNewlines).takeIfNotEmpty
                )
            }

            return products.isEmpty ? .empty : .success(products)
        } catch {
            return .error(L("network_error"))
        }
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
                  (200..<300).contains(httpResponse.statusCode) || httpResponse.statusCode == 404 else {
                return .failure
            }

            if httpResponse.statusCode == 404 {
                return .notFound
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

    private func searchURL(for query: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "world.openfoodfacts.org"
        components.path = "/cgi/search.pl"
        components.queryItems = [
            URLQueryItem(name: "search_terms", value: query),
            URLQueryItem(name: "search_simple", value: "1"),
            URLQueryItem(name: "action", value: "process"),
            URLQueryItem(name: "json", value: "1"),
            URLQueryItem(name: "page_size", value: "20"),
            URLQueryItem(name: "fields", value: "code,product_name,brands,image_url")
        ]
        return components.url
    }
}

private extension Optional where Wrapped == String {
    var takeIfNotEmpty: String? {
        guard let value = self?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else {
            return nil
        }
        return value
    }
}
