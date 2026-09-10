import Foundation
import SwiftData

let maxHistoryEntries = 300

struct HistoryEntryMetadata: Equatable {
    let barcode: String
    let timestamp: Date
}

func historyBarcodesToTrim(
    entries: [HistoryEntryMetadata],
    limit: Int = maxHistoryEntries
) -> Set<String> {
    guard limit >= 0 else { return Set(entries.map(\.barcode)) }
    let sorted = entries.sorted { $0.timestamp > $1.timestamp }
    return Set(sorted.dropFirst(limit).map(\.barcode))
}

@MainActor
func saveScanRecord(
    barcode: String,
    product: Product,
    verdict: VeganStatus?,
    in modelContext: ModelContext,
    timestamp: Date = Date()
) {
    do {
        let descriptor = FetchDescriptor<ScanRecord>(predicate: #Predicate { $0.barcode == barcode })
        if let existing = try modelContext.fetch(descriptor).first {
            existing.productName = product.productName
            existing.brand = product.brands
            existing.imageURL = product.imageUrl
            existing.timestamp = timestamp
            if let verdict {
                existing.verdict = verdict.persistedValue
            }
        } else {
            modelContext.insert(
                ScanRecord(
                    barcode: barcode,
                    productName: product.productName,
                    brand: product.brands,
                    imageURL: product.imageUrl,
                    timestamp: timestamp,
                    verdict: verdict?.persistedValue
                )
            )
        }

        let entries = try modelContext.fetch(FetchDescriptor<ScanRecord>())
        let barcodesToTrim = historyBarcodesToTrim(
            entries: entries.map { HistoryEntryMetadata(barcode: $0.barcode, timestamp: $0.timestamp) }
        )
        entries
            .filter { barcodesToTrim.contains($0.barcode) }
            .forEach(modelContext.delete)
        try modelContext.save()
    } catch {
        print("No se pudo guardar el historial: \(error)")
    }
}
