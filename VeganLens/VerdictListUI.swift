import SwiftUI

struct VerdictChip: View {
    let status: VeganStatus
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafePalette = false

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(veganVerdictColor(for: status, colorblindSafe: colorblindSafePalette))
                .frame(width: 8, height: 8)
            Text(verdictLabel(for: status))
                .appFont(.caption, weight: .semibold)
        }
        .foregroundStyle(veganVerdictColor(for: status, colorblindSafe: colorblindSafePalette))
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(
            veganVerdictColor(for: status, colorblindSafe: colorblindSafePalette)
                .opacity(0.12)
        )
        .clipShape(Capsule())
    }
}

struct ListFilterControls: View {
    @Binding var selectedVerdicts: Set<VeganStatus>
    @Binding var selectedCategories: Set<ProductCategory>
    let availableCategories: [ProductCategory]
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafePalette = false
    @State private var isPresented = false

    private let statuses: [VeganStatus] = [.vegan, .maybe, .notVegan, .unknown]

    var body: some View {
        Button {
            isPresented = true
        } label: {
            Label(
                selectedVerdicts.count + selectedCategories.count == 0
                    ? L("filters_label")
                    : LF("filters_button", selectedVerdicts.count + selectedCategories.count),
                systemImage: "line.3.horizontal.decrease.circle"
            )
        }
        .buttonStyle(.bordered)
        .accessibilityLabel(
            selectedVerdicts.count + selectedCategories.count == 0
                ? L("filters_label")
                : LF("filters_button", selectedVerdicts.count + selectedCategories.count)
        )
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                Form {
                    Section(L("filter_verdict_section")) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))], alignment: .leading) {
                            ForEach(statuses, id: \.persistedValue) { status in
                                filterChip(
                                    title: verdictFilterLabel(for: status),
                                    selected: selectedVerdicts.contains(status),
                                    verdict: status
                                ) {
                                    if selectedVerdicts.contains(status) {
                                        selectedVerdicts.remove(status)
                                    } else {
                                        selectedVerdicts.insert(status)
                                    }
                                }
                            }
                        }
                    }
                    if !availableCategories.isEmpty {
                        Section(L("filter_category_section")) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))], alignment: .leading) {
                                ForEach(availableCategories, id: \.rawValue) { category in
                                    filterChip(
                                        title: category.localizedName,
                                        selected: selectedCategories.contains(category)
                                    ) {
                                        if selectedCategories.contains(category) {
                                            selectedCategories.remove(category)
                                        } else {
                                            selectedCategories.insert(category)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if !selectedVerdicts.isEmpty || !selectedCategories.isEmpty {
                        Section {
                            Button(L("clear_filters")) {
                                selectedVerdicts.removeAll()
                                selectedCategories.removeAll()
                            }
                        }
                    }
                }
                .navigationTitle(L("filters_title"))
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(L("done")) { isPresented = false }
                    }
                }
            }
        }
    }

    private func filterChip(
        title: String,
        selected: Bool,
        verdict: VeganStatus? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let verdict {
                    Circle()
                        .fill(veganVerdictColor(for: verdict, colorblindSafe: colorblindSafePalette))
                        .frame(width: 8, height: 8)
                }
                Text(title)
                    .appFont(.caption, weight: .semibold)
            }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(selected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(selected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}

struct ProductCategoryChip: View {
    let category: ProductCategory

    var body: some View {
        Text(category.localizedName)
            .appFont(.caption, weight: .semibold)
            .foregroundStyle(Color(.secondaryLabel))
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(Color(.secondarySystemBackground))
            .clipShape(Capsule())
    }
}

func verdictFilterLabel(for status: VeganStatus) -> String {
    switch status {
    case .vegan:
        return L("filter_verdict_vegan")
    case .maybe:
        return L("filter_verdict_maybe")
    case .notVegan:
        return L("filter_verdict_not_vegan")
    case .unknown:
        return L("filter_verdict_unknown")
    }
}

func verdictLabel(for status: VeganStatus) -> String {
    switch status {
    case .vegan:
        return L("share_verdict_apto")
    case .notVegan:
        return L("share_verdict_no_apto")
    case .maybe:
        return L("share_verdict_dudoso")
    case .unknown:
        return L("share_verdict_sin_datos")
    }
}
