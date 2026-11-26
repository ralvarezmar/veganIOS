import Foundation
import SwiftData
import SwiftUI
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
    static let lastAttemptKey = "product_update_last_attempt_at"
    static let batchStartedKey = "product_update_batch_at"
    static let pendingKey = "product_update_pending"
    static let historyOffsetKey = "product_update_history_offset"
    static let journalKey = "product_change_journal_v1"
    static let retryInterval: TimeInterval = 15 * 60
}

struct CheckEvidence: Codable, Equatable {
    let reason: String
    let examples: [String]

    init(reason: String, examples: [String]) {
        self.reason = reason
        self.examples = examples
    }

    init?(analysis: VeganAnalysis) {
        guard let reason = analysis.reason else { return nil }
        self.reason = String(describing: reason.source)
        examples = Array(Set(reason.evidence
            .map { String($0.trimmingCharacters(in: .whitespacesAndNewlines).prefix(96)) }
            .filter { !$0.isEmpty }))
            .sorted()
            .prefix(8)
            .map { $0 }
    }

    var veganReason: VeganReason? {
        VeganReasonSource.allCases.first { String(describing: $0) == reason }
            .map { VeganReason(source: $0, evidence: examples) }
    }
}

struct CheckedProduct: Codable, Equatable {
    let barcode: String
    let verdict: String
    let evidence: CheckEvidence?
    let source: String
    let checkedAt: Date

    var status: VeganStatus { VeganStatus(persisted: verdict) }
}

struct ProductChange: Codable, Equatable {
    let name: String
    let before: String
    let previousCheck: CheckedProduct?
    let after: CheckedProduct
    let cachedBeforeEvidence: CheckEvidence?

    var beforeStatus: VeganStatus { VeganStatus(persisted: before) }
}

struct ChangeJournal: Codable, Equatable {
    var snapshots: [CheckedProduct] = []
    var changes: [ProductChange] = []

    /// Records a check and returns the change it reveals, if any. Repeating the same result is not a new change.
    func observing(
        name: String,
        before: VeganStatus?,
        after: CheckedProduct,
        cachedBefore: VeganAnalysis? = nil
    ) -> (ChangeJournal, ProductChange?) {
        let latest = snapshots.first { $0.barcode == after.barcode }
        let prior = latest.flatMap { $0.status == before ? $0 : nil }
        let cachedEvidence = prior == nil && cachedBefore?.status == before ? cachedBefore.flatMap(CheckEvidence.init(analysis:)) : nil
        let oldEvidence = prior?.evidence ?? cachedEvidence
        let changedEvidence = oldEvidence != nil && after.evidence != nil && oldEvidence != after.evidence
        let lastChange = changes.first { $0.after.barcode == after.barcode }
        let alreadyRecorded = latest?.verdict == after.verdict && latest?.evidence == after.evidence &&
            lastChange.map { $0.beforeStatus == before && $0.after.verdict == after.verdict && $0.after.evidence == after.evidence } == true
        var change: ProductChange?
        if !alreadyRecorded, let before, before != after.status || changedEvidence {
            change = ProductChange(
                name: String(name.prefix(180)),
                before: before.persistedValue,
                previousCheck: prior,
                after: after,
                cachedBeforeEvidence: cachedEvidence
            )
        }
        var next = self
        next.snapshots = Array(([after] + snapshots.filter { $0.barcode != after.barcode }).prefix(200))
        if let change {
            next.changes = Array(([change] + changes).prefix(50))
        }
        return (next, change)
    }
}

enum ProductChangeStore {
    static func load(_ defaults: UserDefaults = .standard) -> ChangeJournal {
        defaults.data(forKey: ProductUpdateSettings.journalKey)
            .flatMap { try? JSONDecoder().decode(ChangeJournal.self, from: $0) } ?? ChangeJournal()
    }

    static func save(_ journal: ChangeJournal, _ defaults: UserDefaults = .standard) {
        if let data = try? JSONEncoder().encode(journal) {
            defaults.set(data, forKey: ProductUpdateSettings.journalKey)
        }
    }
}

struct UpdateBatch: Equatable {
    let pending: Set<String>
    let favoritesOffset: Int
    let historyOffset: Int
    let startedAt: Date?
}

/// Keeps an unfinished batch until the next daily check is due, so failed lookups are retried instead of skipped.
func planUpdateBatch(favorites: [String], history: [String], previous: UpdateBatch, now: Date) -> UpdateBatch {
    if !previous.pending.isEmpty, !isProductUpdateCheckDue(lastCheckAt: previous.startedAt, now: now) {
        return previous
    }
    let favoriteBatch = rotatingBatch(favorites, offset: previous.favoritesOffset, limit: ProductUpdateSettings.maxFavoriteChecks)
    let historyBatch = rotatingBatch(history, offset: previous.historyOffset, limit: ProductUpdateSettings.maxChecks)
    return UpdateBatch(
        pending: Set(favoriteBatch.items + historyBatch.items),
        favoritesOffset: favoriteBatch.nextOffset,
        historyOffset: historyBatch.nextOffset,
        startedAt: now
    )
}

func isCompletedLookup(_ result: OpenFactsFetchResult) -> Bool {
    switch result {
    case .notFound: return true
    case .success(let fetched): return !fetched.incompleteLookup
    case .error: return false
    }
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
        let lastSuccess = defaults.object(forKey: ProductUpdateSettings.lastCheckKey) as? Date
        guard !isRunning, isProductUpdateCheckDue(lastCheckAt: lastSuccess, now: now) else { return }
        if let attempt = defaults.object(forKey: ProductUpdateSettings.lastAttemptKey) as? Date {
            let elapsed = now.timeIntervalSince(attempt)
            if elapsed >= 0 && elapsed < ProductUpdateSettings.retryInterval { return }
        }
        isRunning = true
        defer { isRunning = false }
        defaults.set(now, forKey: ProductUpdateSettings.lastAttemptKey)

        let favorites = ((try? modelContext.fetch(FetchDescriptor<FavoriteProduct>(
            sortBy: [SortDescriptor(\.addedAt), SortDescriptor(\.barcode)]
        ))) ?? []).filter { !isMedicine(barcode: $0.barcode, category: $0.category) }
        let unknown: String? = VeganStatus.unknown.persistedValue
        let since = now.addingTimeInterval(-ProductUpdateSettings.maxAge)
        let history = ((try? modelContext.fetch(FetchDescriptor<ScanRecord>(
            predicate: #Predicate { $0.verdict == unknown && $0.timestamp >= since },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        ))) ?? []).filter { !isMedicine(barcode: $0.barcode, category: $0.category) }
        var favoritesByCode: [String: FavoriteProduct] = [:]
        favorites.forEach { favoritesByCode[$0.barcode] = favoritesByCode[$0.barcode] ?? $0 }
        var historyByCode: [String: ScanRecord] = [:]
        history.forEach { historyByCode[$0.barcode] = historyByCode[$0.barcode] ?? $0 }

        let previous = UpdateBatch(
            pending: Set(defaults.stringArray(forKey: ProductUpdateSettings.pendingKey) ?? []),
            favoritesOffset: defaults.integer(forKey: ProductUpdateSettings.favoriteOffsetKey),
            historyOffset: defaults.integer(forKey: ProductUpdateSettings.historyOffsetKey),
            startedAt: defaults.object(forKey: ProductUpdateSettings.batchStartedKey) as? Date
        )
        let batch = planUpdateBatch(
            favorites: favorites.map(\.barcode).uniqued(),
            history: history.map(\.barcode).uniqued(),
            previous: previous,
            now: now
        )
        if batch != previous {
            defaults.set(batch.favoritesOffset, forKey: ProductUpdateSettings.favoriteOffsetKey)
            defaults.set(batch.historyOffset, forKey: ProductUpdateSettings.historyOffsetKey)
            defaults.set(batch.startedAt, forKey: ProductUpdateSettings.batchStartedKey)
            defaults.set(Array(batch.pending), forKey: ProductUpdateSettings.pendingKey)
        }

        var pending = batch.pending
        var historyNames: [String] = []
        var favoriteChanges: [ProductChange] = []
        var journal = ProductChangeStore.load(defaults)
        for barcode in batch.pending.sorted() {
            guard !Task.isCancelled else { break }
            let outcome = await checkCandidate(
                barcode: barcode,
                favorite: favoritesByCode[barcode],
                scan: historyByCode[barcode],
                now: now,
                journal: &journal,
                in: modelContext,
                service: service
            )
            guard outcome.completed else { continue }
            if let name = outcome.historyName { historyNames.append(name) }
            if let change = outcome.favoriteChange { favoriteChanges.append(change) }
            pending.remove(barcode)
            defaults.set(Array(pending), forKey: ProductUpdateSettings.pendingKey)
        }
        ProductChangeStore.save(journal, defaults)
        try? modelContext.save()
        if !historyNames.isEmpty {
            await notify(updatedNames: historyNames)
        }
        if !favoriteChanges.isEmpty {
            await notifyFavorites(changes: favoriteChanges)
        }
        if pending.isEmpty {
            defaults.set(now, forKey: ProductUpdateSettings.lastCheckKey)
            defaults.removeObject(forKey: ProductUpdateSettings.pendingKey)
        }
    }

    private static func isMedicine(barcode: String, category: String?) -> Bool {
        category?.productCategory() == .medicine || isMedicineBarcode(barcode)
    }

    private static func checkCandidate(
        barcode: String,
        favorite: FavoriteProduct?,
        scan: ScanRecord?,
        now: Date,
        journal: inout ChangeJournal,
        in modelContext: ModelContext,
        service: OpenFactsService
    ) async -> (completed: Bool, historyName: String?, favoriteChange: ProductChange?) {
        guard favorite != nil || scan != nil else { return (true, nil, nil) }
        let cached = cachedProduct(barcode: barcode, in: modelContext)
        let result = await service.fetchProduct(barcode: barcode)
        guard isCompletedLookup(result) else { return (false, nil, nil) }
        guard case .success(let fetched) = result else { return (true, nil, nil) }

        let analysis = analyzeVegan(fetched.product, displayLanguage: nil)
        let status = analysis.status
        let favoriteBefore = favorite?.verdict.map { VeganStatus(persisted: $0) }
        let explainHistory = scan != nil && status != .unknown &&
            !hasFavoriteVerdictChanged(stored: favorite?.verdict, current: status)
        let stored: VeganStatus? = explainHistory || (favoriteBefore == nil && scan != nil) ? .unknown : favoriteBefore
        if status == .unknown && stored != .unknown { return (true, nil, nil) }

        let after = CheckedProduct(
            barcode: barcode,
            verdict: status.persistedValue,
            evidence: CheckEvidence(analysis: analysis),
            source: fetched.source.rawValue,
            checkedAt: now
        )
        let name = [favorite?.productName, scan?.productName, fetched.product.productName]
            .compactMap { $0 }
            .first { !$0.isEmpty } ?? barcode
        let (next, change) = journal.observing(
            name: name,
            before: stored,
            after: after,
            cachedBefore: cached.map { analyzeVegan($0, displayLanguage: nil) }
        )
        journal = next

        if status != .unknown {
            favorite?.verdict = status.persistedValue
            updateHistoryVerdict(barcode: barcode, status: status, in: modelContext)
            if let scan, scan.productName?.isEmpty ?? true {
                scan.productName = fetched.product.productName
            }
        }
        guard let change else { return (true, nil, nil) }
        if scan != nil && explainHistory { return (true, name, nil) }
        return (true, nil, favorite != nil ? change : nil)
    }

    private static func cachedProduct(barcode: String, in modelContext: ModelContext) -> Product? {
        let descriptor = FetchDescriptor<CachedProduct>(predicate: #Predicate { $0.barcode == barcode })
        return (try? modelContext.fetch(descriptor).first)
            .flatMap { $0 }
            .flatMap { try? JSONDecoder().decode(Product.self, from: $0.productData) }
    }

    private static func updateHistoryVerdict(barcode: String, status: VeganStatus, in modelContext: ModelContext) {
        let descriptor = FetchDescriptor<ScanRecord>(predicate: #Predicate { $0.barcode == barcode })
        for record in (try? modelContext.fetch(descriptor)) ?? [] {
            record.verdict = status.persistedValue
        }
    }

    private static func notifyFavorites(changes: [ProductChange]) async {
        let body: String
        if changes.contains(where: { $0.beforeStatus == $0.after.status }) {
            body = L("updates_changes_title")
        } else if changes.count == 1, let change = changes.first {
            switch change.after.status {
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

private extension Array where Element == String {
    func uniqued() -> [String] {
        var seen = Set<String>()
        return filter { seen.insert($0).inserted }
    }
}

struct ProductChangesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var changes: [ProductChange] = ProductChangeStore.load().changes
    let onSelectBarcode: (String) -> Void

    var body: some View {
        NavigationStack {
            List {
                if changes.isEmpty {
                    Text(L("updates_changes_empty"))
                        .foregroundStyle(.secondary)
                }
                ForEach(Array(changes.enumerated()), id: \.offset) { _, change in
                    Button {
                        onSelectBarcode(change.after.barcode)
                        dismiss()
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(change.name).appFont(.headline, weight: .semibold)
                            Text(change.after.barcode).appFont(.caption).foregroundStyle(.secondary)
                            ProductChangeStageView(
                                label: L("updates_changes_before"),
                                status: change.beforeStatus,
                                check: change.previousCheck,
                                cachedEvidence: change.cachedBeforeEvidence
                            )
                            ProductChangeStageView(
                                label: L("updates_changes_after"),
                                status: change.after.status,
                                check: change.after,
                                cachedEvidence: nil
                            )
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle(L("updates_changes_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L("back")) { dismiss() }
                }
            }
        }
    }
}

private struct ProductChangeStageView: View {
    let label: String
    let status: VeganStatus
    let check: CheckedProduct?
    let cachedEvidence: CheckEvidence?

    var body: some View {
        let evidence = check?.evidence ?? cachedEvidence
        let explanation = veganReasonText(evidence?.veganReason)
        VStack(alignment: .leading, spacing: 4) {
            Text(label).appFont(.subheadline, weight: .semibold)
            VerdictChip(status: status)
            if let check {
                Text("\((ProductSource(rawValue: check.source) ?? .openFoodFacts).displayName) · \(check.checkedAt.formatted(date: .abbreviated, time: .shortened))")
                    .appFont(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(explanation ?? L("updates_changes_no_evidence")).appFont(.subheadline)
            if let evidence, !evidence.examples.isEmpty,
               !evidence.examples.allSatisfy({ explanation?.contains($0) == true }) {
                Text(evidence.examples.joined(separator: ", "))
                    .appFont(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
