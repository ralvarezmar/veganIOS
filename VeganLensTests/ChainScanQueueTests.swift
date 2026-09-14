import XCTest
@testable import VeganLens

@MainActor
final class ChainScanQueueTests: XCTestCase {
    func testProcessesRequestsSeriallyInEnqueueOrder() async {
        let recorder = ChainScanQueueRecorder()
        let expected = (1...5).map { "barcode-\($0)" }
        let finished = expectation(description: "all barcodes processed")
        finished.expectedFulfillmentCount = expected.count

        let queue = ChainScanQueue(gapNanoseconds: 0) { barcode in
            recorder.begin(barcode)
            try? await Task.sleep(nanoseconds: 1)
            recorder.end(barcode)
            finished.fulfill()
        }

        for barcode in expected {
            await queue.enqueue(barcode)
        }

        await fulfillment(of: [finished], timeout: 2)

        XCTAssertEqual(recorder.maximumConcurrency, 1)
        XCTAssertEqual(recorder.processed, expected)
    }
}

@MainActor
private final class ChainScanQueueRecorder {
    private(set) var currentConcurrency = 0
    private(set) var maximumConcurrency = 0
    private(set) var processed: [String] = []

    func begin(_ barcode: String) {
        currentConcurrency += 1
        maximumConcurrency = max(maximumConcurrency, currentConcurrency)
    }

    func end(_ barcode: String) {
        processed.append(barcode)
        currentConcurrency -= 1
    }
}
