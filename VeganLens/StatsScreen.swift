import SwiftUI
import SwiftData

struct StatsScreen: View {
    @Query private var records: [ScanRecord]
    @Query private var favorites: [FavoriteProduct]
    @Query private var shoppingItems: [ShoppingListItem]

    private var stats: ScanStats {
        computeScanStats(
            records.map { ScanStatsInput(verdict: $0.verdict, category: $0.category, timestamp: $0.timestamp) },
            now: Date()
        )
    }

    var body: some View {
        Group {
            if records.isEmpty {
                ContentUnavailableView(
                    L("stats_empty_title"),
                    systemImage: "chart.bar",
                    description: Text(L("stats_empty_message"))
                )
            } else {
                content(stats)
            }
        }
        .navigationTitle(L("stats_title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func content(_ stats: ScanStats) -> some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(stats.total)")
                        .appFont(.largeTitle, weight: .bold)
                    Text(L("stats_total_scans"))
                        .appFont(.headline)
                }
                .accessibilityElement(children: .combine)
                statRow(L("stats_last_30_days"), stats.lastThirtyDays)
                if let percent = stats.veganPercent {
                    Text(LF("stats_vegan_share", percent))
                        .appFont(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Section(L("stats_verdicts_title")) {
                ForEach([VeganStatus.vegan, .maybe, .notVegan, .unknown], id: \.self) { status in
                    HStack {
                        VerdictChip(status: status)
                        Spacer()
                        Text("\(verdictCount(status, in: stats))")
                            .appFont(.body, weight: .semibold)
                    }
                    .accessibilityElement(children: .combine)
                }
            }

            if !stats.topCategories.isEmpty {
                Section(L("stats_top_categories")) {
                    ForEach(stats.topCategories, id: \.category) { entry in
                        statRow(entry.category.localizedName, entry.count)
                    }
                }
            }

            Section {
                statRow(L("stats_favorites"), favorites.count)
                statRow(L("stats_shopping_list"), shoppingItems.filter { !$0.checked }.count)
            } footer: {
                Text(L("stats_local_note"))
            }
        }
        .listStyle(.insetGrouped)
    }

    private func verdictCount(_ status: VeganStatus, in stats: ScanStats) -> Int {
        switch status {
        case .vegan: return stats.vegan
        case .notVegan: return stats.notVegan
        case .maybe: return stats.maybe
        case .unknown: return stats.unknown
        }
    }

    private func statRow(_ label: String, _ value: Int) -> some View {
        HStack {
            Text(label)
                .appFont(.body)
            Spacer()
            Text("\(value)")
                .appFont(.body, weight: .semibold)
        }
        .accessibilityElement(children: .combine)
    }
}
