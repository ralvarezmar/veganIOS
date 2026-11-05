import SwiftUI

struct GlossaryScreen: View {
    @State private var query = ""
    private let additives = allAdditiveEntries()

    private var filteredIngredients: [GlossaryIngredient] {
        GlossaryIngredient.allCases.filter { entry in
            glossaryQueryMatches(query, [entry.name, entry.explanation] + entry.keywords)
        }
    }

    private var filteredAdditives: [AdditiveEntry] {
        additives.filter { glossaryQueryMatches(query, [$0.code, $0.info.commonName, $0.info.note]) }
    }

    var body: some View {
        let ingredients = filteredIngredients
        let additiveResults = filteredAdditives
        List {
            if ingredients.isEmpty && additiveResults.isEmpty {
                Text(L("glossary_no_results"))
                    .appFont(.body)
                    .foregroundStyle(.secondary)
            }
            if !ingredients.isEmpty {
                Section(L("glossary_ingredients_section")) {
                    ForEach(ingredients) { entry in
                        GlossaryRow(title: entry.name, subtitle: nil, detail: entry.explanation)
                    }
                }
            }
            if !additiveResults.isEmpty {
                Section(L("glossary_additives_section")) {
                    ForEach(additiveResults) { additive in
                        GlossaryRow(
                            title: [additive.code, additive.info.commonName].compactMap { $0 }.joined(separator: " · "),
                            subtitle: "\(L("additive_origin_label")): \(additiveOriginLabel(additive.info.origin))",
                            detail: additive.info.note
                        )
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $query, prompt: L("glossary_search_hint"))
        .navigationTitle(L("glossary_title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct GlossaryRow: View {
    let title: String
    let subtitle: String?
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .appFont(.headline, weight: .semibold)
            if let subtitle {
                Text(subtitle)
                    .appFont(.caption, weight: .semibold)
                    .foregroundStyle(Color.accentColor)
            }
            if !detail.isEmpty {
                Text(detail)
                    .appFont(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}
