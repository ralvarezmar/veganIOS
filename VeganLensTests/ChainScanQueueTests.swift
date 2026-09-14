import XCTest
@testable import VeganLens

@MainActor
final class ChainScanQueueTests: XCTestCase {
    func testProcessesRequestsSeriallyInEnqueueOrder() async {
        var currentConcurrency = 0
        var maximumConcurrency = 0
        var processed: [String] = []
        let expected = (1...5).map { "barcode-\($0)" }
        let finished = expectation(description: "all barcodes processed")
        finished.expectedFulfillmentCount = expected.count

        let queue = ChainScanQueue(gapNanoseconds: 0) { barcode in
            currentConcurrency += 1
            maximumConcurrency = max(maximumConcurrency, currentConcurrency)
            try? await Task.sleep(nanoseconds: 1)
            processed.append(barcode)
            currentConcurrency -= 1
            finished.fulfill()
        }

        for barcode in expected {
            await queue.enqueue(barcode)
        }

        await fulfillment(of: [finished], timeout: 2)

        XCTAssertEqual(maximumConcurrency, 1)
        XCTAssertEqual(processed, expected)
    }
}
