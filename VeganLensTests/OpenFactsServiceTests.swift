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
