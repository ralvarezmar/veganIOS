import Foundation
import SwiftData
import UserNotifications

enum ProductUpdateSettings {
    static let lastCheckKey = "product_update_last_check_at"
    static let checkInterval: TimeInterval = 24 * 60 * 60
    static let maxAge: TimeInterval = 30 * 24 * 60 * 60
    static let maxChecks = 10
    static let notificationIdentifier = "product-updates"
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

        let unknown: String? = VeganStatus.unknown.persistedValue
        let since = now.addingTimeInterval(-ProductUpdateSettings.maxAge)
        var descriptor = FetchDescriptor<ScanRecord>(
            predicate: #Predicate { $0.verdict == unknown && $0.timestamp >= since },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        descriptor.fetchLimit = ProductUpdateSettings.maxChecks
        guard let candidates = try? modelContext.fetch(descriptor), !candidates.isEmpty else { return }

        var updatedNames: [String] = []
        for record in candidates {
            guard case .success(let fetched) = await service.fetchProduct(barcode: record.barcode) else { continue }
            let status = analyzeVegan(fetched.product).status
            guard status != .unknown else { continue }
            record.verdict = status.persistedValue
            if record.productName?.isEmpty ?? true {
                record.productName = fetched.product.productName
            }
            updatedNames.append(record.productName?.isEmpty == false ? record.productName! : record.barcode)
        }
        guard !updatedNames.isEmpty else { return }
        try? modelContext.save()
        await notify(updatedNames: updatedNames)
    }

    private static func notify(updatedNames: [String]) async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = L("product_update_notification_title")
        content.body = updatedNames.count == 1
            ? LF("product_update_notification_single", updatedNames[0])
            : LF("product_update_notification_multiple", updatedNames.count)
        content.sound = .default
        let request = UNNotificationRequest(
            identifier: ProductUpdateSettings.notificationIdentifier,
            content: content,
            trigger: nil
        )
        try? await center.add(request)
    }
}
