import Foundation
import SwiftData
import UserNotifications

enum ProductUpdateSettings {
    static let lastCheckKey = "product_update_last_check_at"
    static let checkInterval: TimeInterval = 24 * 60 * 60
    static let maxAge: TimeInterval = 30 * 24 * 60 * 60
    static let maxChecks = 10
    static let notificationIdentifier = "product-updates"
    static let maxFavoriteChecks = 10
    static let favoriteOffsetKey = "favorite_update_offset"
    static let favoriteNotificationIdentifier = "favorite-verdict-updates"
}

struct RotatingBatch<Element> {
    let items: [Element]
    let nextOffset: Int
}

func rotatingBatch<Element>(_ items: [Element], offset: Int, limit: Int) -> RotatingBatch<Element> {
    guard !items.isEmpty, limit > 0 else { return RotatingBatch(items: [], nextOffset: 0) }
    let start = ((offset % items.count) + items.count) % items.count
    let count = min(limit, items.count)
    return RotatingBatch(
        items: (0..<count).map { items[(start + $0) % items.count] },
        nextOffset: (start + count) % items.count
    )
}

func hasFavoriteVerdictChanged(stored: String?, current: VeganStatus) -> Bool {
    guard current != .unknown, let stored else { return false }
    return stored != current.persistedValue
}

struct FavoriteVerdictChange {
    let name: String
    let status: VeganStatus
}

func isProductUpdateCheckDue(lastCheckAt: Date?, now: Date) -> Bool {
    guard let lastCheckAt else { return true }
    let elapsed = now.timeIntervalSince(lastCheckAt)
    return elapsed >= ProductUpdateSettings.checkInterval || elapsed < 0
}

@MainActor
enum ProductUpdateChecker {
    private static var isRunning = false

    static func runIfDue(
        in modelContext: ModelContext,
        service: OpenFactsService = OpenFactsService(),
        now: Date = Date()
    ) async {
        let defaults = UserDefaults.standard
        let lastCheckAt = defaults.object(forKey: ProductUpdateSettings.lastCheckKey) as? Date
        guard !isRunning, isProductUpdateCheckDue(lastCheckAt: lastCheckAt, now: now) else { return }
        isRunning = true
        defer { isRunning = false }
        defaults.set(now, forKey: ProductUpdateSettings.lastCheckKey)

        let updatedRecords = await checkUnknownHistory(in: modelContext, service: service, now: now)
        let favoriteChanges = await checkFavorites(
            in: modelContext,
            service: service,
            skipping: Set(updatedRecords.map { $0.barcode })
        )
        guard !updatedRecords.isEmpty || !favoriteChanges.isEmpty else { return }
        try? modelContext.save()
        if !updatedRecords.isEmpty {
            await notify(updatedNames: updatedRecords.map { $0.name })
        }
        if !favoriteChanges.isEmpty {
            await notifyFavorites(changes: favoriteChanges)
        }
    }

    private static func checkUnknownHistory(
        in modelContext: ModelContext,
        service: OpenFactsService,
        now: Date
    ) async -> [(barcode: String, name: String)] {
        let unknown: String? = VeganStatus.unknown.persistedValue
        let since = now.addingTimeInterval(-ProductUpdateSettings.maxAge)
        var descriptor = FetchDescriptor<ScanRecord>(
            predicate: #Predicate { $0.verdict == unknown && $0.timestamp >= since },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        descriptor.fetchLimit = ProductUpdateSettings.maxChecks
        guard let candidates = try? modelContext.fetch(descriptor), !candidates.isEmpty else { return [] }

        var updated: [(barcode: String, name: String)] = []
        for record in candidates {
            guard case .success(let fetched) = await service.fetchProduct(barcode: record.barcode) else { continue }
            let status = analyzeVegan(fetched.product).status
            guard status != .unknown else { continue }
            record.verdict = status.persistedValue
            if record.productName?.isEmpty ?? true {
                record.productName = fetched.product.productName
            }
            updated.append((record.barcode, record.productName?.isEmpty == false ? record.productName! : record.barcode))
        }
        return updated
    }

    private static func checkFavorites(
        in modelContext: ModelContext,
        service: OpenFactsService,
        skipping skippedBarcodes: Set<String>
    ) async -> [FavoriteVerdictChange] {
        let descriptor = FetchDescriptor<FavoriteProduct>(
            sortBy: [SortDescriptor(\.addedAt), SortDescriptor(\.barcode)]
        )
        let defaults = UserDefaults.standard
        let batch = rotatingBatch(
            (try? modelContext.fetch(descriptor)) ?? [],
            offset: defaults.integer(forKey: ProductUpdateSettings.favoriteOffsetKey),
            limit: ProductUpdateSettings.maxFavoriteChecks
        )
        defaults.set(batch.nextOffset, forKey: ProductUpdateSettings.favoriteOffsetKey)

        var changes: [FavoriteVerdictChange] = []
        for favorite in batch.items where !skippedBarcodes.contains(favorite.barcode) {
            guard case .success(let fetched) = await service.fetchProduct(barcode: favorite.barcode) else { continue }
            let status = analyzeVegan(fetched.product).status
            guard status != .unknown, favorite.verdict != status.persistedValue else { continue }
            let changed = hasFavoriteVerdictChanged(stored: favorite.verdict, current: status)
            favorite.verdict = status.persistedValue
            updateHistoryVerdict(barcode: favorite.barcode, status: status, in: modelContext)
            if changed {
                let name = [favorite.productName, fetched.product.productName]
                    .compactMap { $0 }
                    .first { !$0.isEmpty } ?? favorite.barcode
                changes.append(FavoriteVerdictChange(name: name, status: status))
            }
        }
        return changes
    }

    private static func updateHistoryVerdict(barcode: String, status: VeganStatus, in modelContext: ModelContext) {
        let descriptor = FetchDescriptor<ScanRecord>(predicate: #Predicate { $0.barcode == barcode })
        for record in (try? modelContext.fetch(descriptor)) ?? [] {
            record.verdict = status.persistedValue
        }
    }

    private static func notifyFavorites(changes: [FavoriteVerdictChange]) async {
        let body: String
        if changes.count == 1, let change = changes.first {
            switch change.status {
            case .vegan:
                body = LF("favorite_update_notification_vegan", change.name)
            case .notVegan:
                body = LF("favorite_update_notification_not_vegan", change.name)
            case .maybe, .unknown:
                body = LF("favorite_update_notification_maybe", change.name)
            }
        } else {
            body = LF("favorite_update_notification_multiple", changes.count)
        }
        await deliver(
            identifier: ProductUpdateSettings.favoriteNotificationIdentifier,
            title: L("favorite_update_notification_title"),
            body: body
        )
    }

    private static func notify(updatedNames: [String]) async {
        await deliver(
            identifier: ProductUpdateSettings.notificationIdentifier,
            title: L("product_update_notification_title"),
            body: updatedNames.count == 1
                ? LF("product_update_notification_single", updatedNames[0])
                : LF("product_update_notification_multiple", updatedNames.count)
        )
    }

    private static func deliver(identifier: String, title: String, body: String) async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        try? await center.add(request)
    }
}
