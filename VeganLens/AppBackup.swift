import Foundation
import SwiftData
import SwiftUI
import UniformTypeIdentifiers

let backupFormat = "veganlens-backup"
let backupVersion = 1

struct BackupHistoryEntry: Codable, Equatable {
    var barcode: String?
    var productName: String?
    var brand: String?
    var imageUrl: String?
    var timestamp: Int64?
    var verdict: String?
    var category: String?
}

struct BackupFavoriteEntry: Codable, Equatable {
    var barcode: String?
    var productName: String?
    var brand: String?
    var imageUrl: String?
    var addedAt: Int64?
    var verdict: String?
    var category: String?
}

struct BackupShoppingEntry: Codable, Equatable {
    var barcode: String?
    var productName: String?
    var brand: String?
    var imageUrl: String?
    var addedAt: Int64?
    var verdict: String?
    var checked: Bool?
}

struct AppBackup: Codable, Equatable {
    var format: String? = backupFormat
    var version: Int? = backupVersion
    var exportedAt: Int64?
    var history: [BackupHistoryEntry]?
    var favorites: [BackupFavoriteEntry]?
    var shoppingList: [BackupShoppingEntry]?
}

struct BackupMergePlan: Equatable {
    let historyToInsert: [BackupHistoryEntry]
    let historyToUpdate: [BackupHistoryEntry]
    let favoritesToInsert: [BackupFavoriteEntry]
    let shoppingToInsert: [BackupShoppingEntry]

    var historyCount: Int { historyToInsert.count + historyToUpdate.count }
}

func backupMillis(_ date: Date) -> Int64 {
    Int64((date.timeIntervalSince1970 * 1000).rounded())
}

func backupDate(_ millis: Int64?) -> Date {
    Date(timeIntervalSince1970: TimeInterval(millis ?? 0) / 1000)
}

func encodeBackup(_ backup: AppBackup) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    return try encoder.encode(backup)
}

func decodeBackup(_ data: Data) -> AppBackup? {
    guard let backup = try? JSONDecoder().decode(AppBackup.self, from: data),
          backup.format == backupFormat,
          let version = backup.version,
          (1...backupVersion).contains(version)
    else { return nil }
    return backup
}

private func nonEmptyBarcode(_ barcode: String?) -> String? {
    guard let barcode, !barcode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
    return barcode
}

func planBackupMerge(
    _ backup: AppBackup,
    existingHistory: [String: Date],
    existingFavoriteBarcodes: Set<String>,
    existingShoppingBarcodes: Set<String>
) -> BackupMergePlan {
    var latestByBarcode: [String: BackupHistoryEntry] = [:]
    var historyOrder: [String] = []
    for entry in backup.history ?? [] {
        guard let barcode = nonEmptyBarcode(entry.barcode) else { continue }
        if let current = latestByBarcode[barcode] {
            if (entry.timestamp ?? 0) > (current.timestamp ?? 0) {
                latestByBarcode[barcode] = entry
            }
        } else {
            latestByBarcode[barcode] = entry
            historyOrder.append(barcode)
        }
    }

    var toInsert: [BackupHistoryEntry] = []
    var toUpdate: [BackupHistoryEntry] = []
    for barcode in historyOrder {
        guard let entry = latestByBarcode[barcode] else { continue }
        if let existing = existingHistory[barcode] {
            if (entry.timestamp ?? 0) > backupMillis(existing) {
                toUpdate.append(entry)
            }
        } else {
            toInsert.append(entry)
        }
    }

    var seenFavorites = existingFavoriteBarcodes
    let favorites = (backup.favorites ?? []).filter { entry in
        guard let barcode = nonEmptyBarcode(entry.barcode) else { return false }
        return seenFavorites.insert(barcode).inserted
    }

    var seenShopping = existingShoppingBarcodes
    let shopping = (backup.shoppingList ?? []).filter { entry in
        guard let barcode = nonEmptyBarcode(entry.barcode) else { return false }
        return seenShopping.insert(barcode).inserted
    }

    return BackupMergePlan(
        historyToInsert: toInsert,
        historyToUpdate: toUpdate,
        favoritesToInsert: favorites,
        shoppingToInsert: shopping
    )
}

@MainActor
func makeBackupData(context: ModelContext, now: Date = Date()) throws -> Data {
    let history = try context.fetch(FetchDescriptor<ScanRecord>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)]))
    let favorites = try context.fetch(FetchDescriptor<FavoriteProduct>(sortBy: [SortDescriptor(\.addedAt, order: .reverse)]))
    let shopping = try context.fetch(FetchDescriptor<ShoppingListItem>(sortBy: [SortDescriptor(\.addedAt, order: .reverse)]))
    let backup = AppBackup(
        exportedAt: backupMillis(now),
        history: history.map {
            BackupHistoryEntry(
                barcode: $0.barcode, productName: $0.productName, brand: $0.brand, imageUrl: $0.imageURL,
                timestamp: backupMillis($0.timestamp), verdict: $0.verdict, category: $0.category
            )
        },
        favorites: favorites.map {
            BackupFavoriteEntry(
                barcode: $0.barcode, productName: $0.productName, brand: $0.brand, imageUrl: $0.imageURL,
                addedAt: backupMillis($0.addedAt), verdict: $0.verdict, category: $0.category
            )
        },
        shoppingList: shopping.map {
            BackupShoppingEntry(
                barcode: $0.barcode, productName: $0.productName, brand: $0.brand, imageUrl: $0.imageURL,
                addedAt: backupMillis($0.addedAt), verdict: $0.verdict, checked: $0.checked
            )
        }
    )
    return try encodeBackup(backup)
}

enum BackupError: Error {
    case invalidFile
}

@MainActor
func importBackup(_ data: Data, context: ModelContext) throws -> BackupMergePlan {
    guard let backup = decodeBackup(data) else { throw BackupError.invalidFile }
    let history = try context.fetch(FetchDescriptor<ScanRecord>())
    let favorites = try context.fetch(FetchDescriptor<FavoriteProduct>())
    let shopping = try context.fetch(FetchDescriptor<ShoppingListItem>())
    let historyByBarcode = Dictionary(history.map { ($0.barcode, $0) }, uniquingKeysWith: { first, _ in first })
    let plan = planBackupMerge(
        backup,
        existingHistory: historyByBarcode.mapValues(\.timestamp),
        existingFavoriteBarcodes: Set(favorites.map(\.barcode)),
        existingShoppingBarcodes: Set(shopping.map(\.barcode))
    )

    for entry in plan.historyToInsert {
        guard let barcode = entry.barcode else { continue }
        context.insert(
            ScanRecord(
                barcode: barcode, productName: entry.productName, brand: entry.brand, imageURL: entry.imageUrl,
                timestamp: backupDate(entry.timestamp), verdict: entry.verdict, category: entry.category
            )
        )
    }
    for entry in plan.historyToUpdate {
        guard let barcode = entry.barcode, let record = historyByBarcode[barcode] else { continue }
        record.productName = entry.productName
        record.brand = entry.brand
        record.imageURL = entry.imageUrl
        record.timestamp = backupDate(entry.timestamp)
        record.verdict = entry.verdict
        record.category = entry.category
    }
    for entry in plan.favoritesToInsert {
        guard let barcode = entry.barcode else { continue }
        context.insert(
            FavoriteProduct(
                barcode: barcode, productName: entry.productName, brand: entry.brand, imageURL: entry.imageUrl,
                addedAt: backupDate(entry.addedAt), verdict: entry.verdict, category: entry.category
            )
        )
    }
    for entry in plan.shoppingToInsert {
        guard let barcode = entry.barcode else { continue }
        context.insert(
            ShoppingListItem(
                barcode: barcode, productName: entry.productName, brand: entry.brand, imageURL: entry.imageUrl,
                verdict: entry.verdict, addedAt: backupDate(entry.addedAt), checked: entry.checked ?? false
            )
        )
    }
    try context.save()

    let allHistory = try context.fetch(FetchDescriptor<ScanRecord>())
    let toTrim = historyBarcodesToTrim(
        entries: allHistory.map { HistoryEntryMetadata(barcode: $0.barcode, timestamp: $0.timestamp) }
    )
    if !toTrim.isEmpty {
        allHistory.filter { toTrim.contains($0.barcode) }.forEach(context.delete)
        try context.save()
    }
    return plan
}

struct BackupDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }

    var data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        data = configuration.file.regularFileContents ?? Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}
