import Foundation
import XCTest
@testable import VeganLens

final class OpenFactsServiceTests: XCTestCase {
    func testVeganOpenFoodFactsProductDoesNotQuerySiblings() async {
        let session = makeSession { request in
            let payload = request.url?.host == ProductSource.openFoodFacts.baseURL.host
                ? #"{"status":1,"product":{"product_name":"Vegan","ingredients_analysis_tags":["en:vegan"]}}"#
                : #"{"status":0}"#
            return self.response(statusCode: 200, body: payload)
        }
        let service = OpenFactsService(session: session)

        let result = await service.fetchProduct(barcode: "123")

        guard case .success(let fetched) = result else {
            return XCTFail("Expected a successful Open Food Facts result")
        }
        XCTAssertEqual(fetched.source, .openFoodFacts)
        XCTAssertEqual(URLProtocolStub.requestedHosts, ["world.openfoodfacts.org"])
    }

    func testSiblingProductsResolveInSourceOrderAndEmitOnlyTwoProgressEvents() async {
        let session = makeSession { request in
            switch request.url?.host {
            case "world.openfoodfacts.org":
                return self.response(statusCode: 200, body: #"{"status":0}"#)
            case "world.openbeautyfacts.org":
                return self.response(
                    statusCode: 200,
                    body: #"{"status":1,"product":{"product_name":"Beauty product"}}"#
                )
            case "world.openproductsfacts.org":
                return self.response(
                    statusCode: 200,
                    body: #"{"status":1,"product":{"product_name":"Products product"}}"#
                )
            default:
                return self.response(statusCode: 200, body: #"{"status":0}"#)
            }
        }
        let service = OpenFactsService(session: session)
        let progress = ProgressRecorder()

        let result = await service.fetchProduct(barcode: "123") { progress.append($0) }

        guard case .success(let fetched) = result else {
            return XCTFail("Expected the first sibling product by source order")
        }
        XCTAssertEqual(fetched.source, .openBeautyFacts)
        XCTAssertEqual(
            progress.values,
            [.querying(.openFoodFacts), .queryingSiblings]
        )
        XCTAssertEqual(
            Set(URLProtocolStub.requestedHosts),
            Set([
                "world.openfoodfacts.org",
                "world.openbeautyfacts.org",
                "world.openproductsfacts.org",
                "world.openpetfoodfacts.org"
            ])
        )
    }

    func testOpenFoodFactsOnlyProgressWhenItResolves() async {
        let session = makeSession { _ in
            self.response(
                statusCode: 200,
                body: #"{"status":1,"product":{"product_name":"Vegan","ingredients_analysis_tags":["en:vegan"]}}"#
            )
        }
        let service = OpenFactsService(session: session)
        let progress = ProgressRecorder()

        _ = await service.fetchProduct(barcode: "123") { progress.append($0) }

        XCTAssertEqual(progress.values, [.querying(.openFoodFacts)])
    }

    func testFailureWithCleanSiblingResponsesReturnsNetworkError() async {
        let session = makeSession { request in
            if request.url?.host == "world.openfoodfacts.org" {
                return self.response(statusCode: 500, body: #"{"status":0}"#)
            }
            return self.response(statusCode: 404, body: #"{"status":0}"#)
        }
        let service = OpenFactsService(session: session)

        let result = await service.fetchProduct(barcode: "123")

        guard case .error = result else {
            return XCTFail("Expected a network error")
        }
    }

    func testAllSourcesRateLimitedReturnsServerBusyError() async {
        let session = makeSession { _ in
            self.response(statusCode: 429, body: #"{"status":0}"#)
        }
        let service = OpenFactsService(session: session)

        let result = await service.fetchProduct(barcode: "123")

        guard case .error(let message) = result else {
            return XCTFail("Expected a server busy error")
        }
        XCTAssertEqual(message, L("server_busy_error"))
    }

    func testSearchByNameUsesSearchaliciousAndJoinsBrandLists() async {
        let session = makeSession { request in
            XCTAssertEqual(request.url?.host, "search.openfoodfacts.org")
            XCTAssertEqual(request.url?.path, "/search")
            return self.response(
                statusCode: 200,
                body: #"{"hits":[{"code":" 8414807544766 ","product_name":"Lentejas","brands":["Consum","Spar"],"image_url":"https://img/1.jpg"},{"code":"","product_name":"Sin código"}]}"#
            )
        }

        let result = await OpenFactsService(session: session).searchByName(query: "lentejas")

        guard case .success(let products) = result else {
            return XCTFail("Expected Search-a-licious results")
        }
        XCTAssertEqual(products.map(\.code), ["8414807544766"])
        XCTAssertEqual(products.first?.brands, "Consum, Spar")
        XCTAssertEqual(URLProtocolStub.requestedHosts, ["search.openfoodfacts.org"])
    }

    func testSearchByNameFallsBackToLegacySearchWhenSearchaliciousFails() async {
        let session = makeSession { request in
            if request.url?.host == "search.openfoodfacts.org" {
                return self.response(statusCode: 503, body: "<html></html>")
            }
            XCTAssertEqual(request.url?.path, "/cgi/search.pl")
            return self.response(
                statusCode: 200,
                body: #"{"products":[{"code":"8480000260291","product_name":"Garbanzos cocidos","brands":"Hacendado"}]}"#
            )
        }

        let result = await OpenFactsService(session: session).searchByName(query: "garbanzos")

        guard case .success(let products) = result else {
            return XCTFail("Expected legacy search results")
        }
        XCTAssertEqual(products.first?.brands, "Hacendado")
    }

    func testSearchByNameIsEmptyWhenSearchaliciousFindsNothingAndLegacyFails() async {
        let session = makeSession { request in
            request.url?.host == "search.openfoodfacts.org"
                ? self.response(statusCode: 200, body: #"{"hits":[]}"#)
                : self.response(statusCode: 503, body: "<html></html>")
        }

        let result = await OpenFactsService(session: session).searchByName(query: "zzzz")

        guard case .empty = result else {
            return XCTFail("Expected an empty result, got \(result)")
        }
    }

    func testSearchByNameReturnsErrorWhenBothSearchesFail() async {
        let session = makeSession { _ in self.response(statusCode: 503, body: "<html></html>") }

        let result = await OpenFactsService(session: session).searchByName(query: "tofu")

        guard case .error = result else {
            return XCTFail("Expected an error, got \(result)")
        }
    }

    private func makeSession(
        handler: @escaping (URLRequest) -> (HTTPURLResponse, Data)
    ) -> URLSession {
        URLProtocolStub.handler = handler
        URLProtocolStub.requestedHosts = []
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: configuration)
    }

    private func response(statusCode: Int, body: String) -> (HTTPURLResponse, Data) {
        (
            HTTPURLResponse(
                url: URL(string: "https://example.com")!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!,
            Data(body.utf8)
        )
    }
}

private final class URLProtocolStub: URLProtocol {
    static var handler: ((URLRequest) -> (HTTPURLResponse, Data))?
    static var requestedHosts: [String] = []

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = Self.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        if let host = request.url?.host {
            Self.requestedHosts.append(host)
        }
        let (response, data) = handler(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

private final class ProgressRecorder: @unchecked Sendable {
    private let lock = NSLock()
    private(set) var values: [FetchProgress] = []

    func append(_ progress: FetchProgress) {
        lock.lock()
        values.append(progress)
        lock.unlock()
    }
}
