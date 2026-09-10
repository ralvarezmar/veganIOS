import Foundation
import Combine

enum ChainScanState: Equatable {
    case loading
    case done
    case error
}

struct ChainScanEntry: Identifiable, Equatable {
    let barcode: String
    var productName: String?
    var verdict: VeganStatus?
    var state: ChainScanState
    let addedAt: Date

    var id: String { barcode }
}

@MainActor
final class ChainScanSession: ObservableObject {
    static let maxVisibleEntries = 10
    static let duplicateWindow: TimeInterval = 3

    @Published private(set) var entries: [ChainScanEntry] = []
    private var lastAcceptedAt: [String: Date] = [:]

    @discardableResult
    func register(barcode: String, now: Date = Date()) -> Bool {
        if let lastAccepted = lastAcceptedAt[barcode],
           now.timeIntervalSince(lastAccepted) < Self.duplicateWindow {
            return false
        }

        lastAcceptedAt[barcode] = now
        entries.removeAll { $0.barcode == barcode }
        entries.insert(
            ChainScanEntry(
                barcode: barcode,
                productName: nil,
                verdict: nil,
                state: .loading,
                addedAt: now
            ),
            at: 0
        )
        entries = Array(entries.prefix(Self.maxVisibleEntries))
        return true
    }

    func update(
        barcode: String,
        productName: String?,
        verdict: VeganStatus?,
        state: ChainScanState
    ) {
        guard let index = entries.firstIndex(where: { $0.barcode == barcode }) else { return }
        entries[index].productName = productName
        entries[index].verdict = verdict
        entries[index].state = state
    }

    func retry(barcode: String) {
        update(barcode: barcode, productName: nil, verdict: nil, state: .loading)
    }

    func clear() {
        entries.removeAll()
        lastAcceptedAt.removeAll()
    }
}
