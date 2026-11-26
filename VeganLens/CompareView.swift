import SwiftUI
import SwiftData

struct LabelComparison {
    let titleKey: String
    let values: [[String]?]
}

struct NutrientComparison {
    let titleKey: String
    let unit: String
    let values: [Double?]
}

func labelComparisons(products: [Product?], tagLabels: ([String]) -> [String]) -> [LabelComparison] {
    func normalized(_ labels: [String]) -> [String] { Array(Set(labels)).sorted() }
    return [
        LabelComparison(titleKey: "allergens_title", values: products.map { $0?.allergensTags.map { normalized(tagLabels($0)) } }),
        LabelComparison(titleKey: "compare_traces", values: products.map { $0?.tracesTags.map { normalized(tagLabels($0)) } }),
        LabelComparison(titleKey: "compare_concerns", values: products.map { product in
            guard let product else { return nil }
            let analysis = analyzeVegan(product)
            let flagged = normalized(analysis.nonVeganIngredients + analysis.doubtfulIngredients)
            return flagged.isEmpty && !analysis.hasIngredientData ? nil : flagged
        })
    ]
}

func nutrientComparisons(products: [Product?], basis: NutritionBasis) -> [NutrientComparison] {
    let sold = basis == .asSold
    func valid(_ value: Double?) -> Double? { value.flatMap { $0.isFinite && $0 >= 0 ? $0 : nil } }
    func row(_ key: String, _ unit: String = "g", _ value: (Nutriments) -> Double?) -> NutrientComparison {
        NutrientComparison(titleKey: key, unit: unit, values: products.map { $0?.nutriments.flatMap { valid(value($0)) } })
    }
    return [
        row("nutrition_energy", "kcal") { n in
            sold ? valid(n.energyKcal100g) ?? valid(n.energyKj100g).map { $0 / 4.184 }
                : valid(n.energyKcalPrepared100g) ?? valid(n.energyKjPrepared100g).map { $0 / 4.184 }
        },
        row("nutrition_fat") { sold ? $0.fat100g : $0.fatPrepared100g },
        row("nutrition_saturated_fat") { sold ? $0.saturatedFat100g : $0.saturatedFatPrepared100g },
        row("nutrition_carbohydrates") { sold ? $0.carbohydrates100g : $0.carbohydratesPrepared100g },
        row("nutrition_sugars") { sold ? $0.sugars100g : $0.sugarsPrepared100g },
        row("nutrition_salt") { sold ? $0.salt100g : $0.saltPrepared100g },
        row("nutrition_proteins") { sold ? $0.proteins100g : $0.proteinsPrepared100g },
        row("nutrition_added_sugars") { sold ? $0.addedSugars100g : $0.addedSugarsPrepared100g }
    ].filter { $0.values.contains { $0 != nil } }
}

func showComparisonRow<T: Equatable>(onlyDifferences: Bool, values: [T], loading: Set<Int>) -> Bool {
    guard onlyDifferences else { return true }
    let visible = values.enumerated().filter { !loading.contains($0.offset) }.map(\.element)
    guard let first = visible.first else { return false }
    return visible.contains { $0 != first }
}

struct CompareView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var cachedProducts: [CachedProduct]
    @State private var fetchedProducts: [String: Product?] = [:]
    @State private var onlyDifferences = false
    private let service = OpenFactsService()

    let records: [ScanRecord]
    let onSelectBarcode: (String) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(records, id: \.barcode) { record in
                    Section {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(record.productName?.isEmpty == false ? record.productName! : record.barcode)
                                .appFont(.headline, weight: .semibold)

                            if let brand = record.brand, !brand.isEmpty {
                                Text(brand)
                                    .appFont(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            HStack(spacing: 6) {
                                if let verdict = record.verdict.map({ VeganStatus(persisted: $0) }) {
                                    VerdictChip(status: verdict)
                                }
                                if let category = record.category {
                                    ProductCategoryChip(category: category.productCategory())
                                }
                            }

                            Button {
                                onSelectBarcode(record.barcode)
                                dismiss()
                            } label: {
                                Text(L("compare_open_product"))
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.vertical, 4)
                    }
                }
                if !records.isEmpty {
                    ComparisonDetailsSection(
                        names: names,
                        medicines: medicineIndices,
                        products: comparisonProducts,
                        loading: loadingIndices,
                        onlyDifferences: $onlyDifferences
                    )
                }
            }
            .task(id: records.map(\.barcode)) { await fetchMissingProducts() }
            .navigationTitle(L("compare_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L("back")) { dismiss() }
                }
            }
        }
    }

    private var names: [String] {
        records.map { record in
            if let name = record.productName, !name.isEmpty, records.filter({ $0.productName == name }).count == 1 {
                return name
            }
            return record.barcode
        }
    }

    private var medicineIndices: Set<Int> {
        Set(records.indices.filter { index in
            records[index].category?.productCategory() == .medicine || isMedicineBarcode(records[index].barcode)
        })
    }

    private var savedProducts: [String: Product] {
        let codes = Set(records.map(\.barcode))
        var result: [String: Product] = [:]
        for cached in cachedProducts where codes.contains(cached.barcode) {
            if let product = try? JSONDecoder().decode(Product.self, from: cached.productData), product.hasUsefulData {
                result[cached.barcode] = product
            }
        }
        return result
    }

    private var comparisonProducts: [Product?] {
        let saved = savedProducts
        return records.indices.map { index in
            guard !medicineIndices.contains(index) else { return nil }
            let code = records[index].barcode
            if let product = saved[code] { return product }
            return fetchedProducts[code].flatMap { $0 }
        }
    }

    private var loadingIndices: Set<Int> {
        let saved = savedProducts
        return Set(records.indices.filter { index in
            let code = records[index].barcode
            return !medicineIndices.contains(index) && saved[code] == nil && fetchedProducts[code] == nil
        })
    }

    private func fetchMissingProducts() async {
        let saved = savedProducts
        for index in records.indices where !medicineIndices.contains(index) {
            let code = records[index].barcode
            guard saved[code] == nil, fetchedProducts[code] == nil else { continue }
            guard !Task.isCancelled else { return }
            if case .success(let fetched) = await service.fetchProduct(barcode: code) {
                fetchedProducts[code] = .some(fetched.product)
            } else {
                fetchedProducts[code] = .some(nil)
            }
        }
    }
}

private struct ComparisonDetailsSection: View {
    let names: [String]
    let medicines: Set<Int>
    let products: [Product?]
    let loading: Set<Int>
    @Binding var onlyDifferences: Bool

    var body: some View {
        let fields = labelComparisons(products: products) { tags in buildAllergenDisplayItems(tags: tags).map(\.label) }
            .filter { showComparisonRow(onlyDifferences: onlyDifferences, values: $0.values, loading: loading) }
        let nutrition: [(NutritionBasis, [NutrientComparison])] = [NutritionBasis.asSold, .prepared].map { basis in
            (basis, nutrientComparisons(products: products, basis: basis)
                .filter { showComparisonRow(onlyDifferences: onlyDifferences, values: $0.values, loading: loading) })
        }
        Section(L("compare_details")) {
            Toggle(L("compare_only_differences"), isOn: $onlyDifferences)
                .accessibilityIdentifier("compare-only-differences")
            ForEach(Array(names.enumerated()), id: \.offset) { index, name in
                if medicines.contains(index) {
                    Text(LF("compare_medicine_unavailable", name))
                } else if loading.contains(index) {
                    Text("\(name): \(L("compare_loading_details"))")
                } else if products[index] == nil {
                    Text("\(name): \(L("compare_unreported"))")
                }
            }
            if products.contains(where: { $0 != nil }) {
                ForEach(fields, id: \.titleKey) { field in
                    ComparisonFieldView(
                        title: L(field.titleKey),
                        names: names,
                        values: field.values.enumerated().map { index, labels in
                            if loading.contains(index) { return L("compare_loading_details") }
                            guard let labels else { return L("compare_unreported") }
                            return labels.isEmpty ? L("compare_none_listed") : labels.joined(separator: ", ")
                        },
                        same: loading.isEmpty && !field.values.contains { $0 != field.values.first! }
                    )
                }
                ForEach(Array(nutrition.enumerated()), id: \.offset) { _, entry in
                    let (basis, rows) = entry
                    if !rows.isEmpty {
                        Text(L(basis == .asSold ? "compare_as_sold" : "nutrition_title_prepared"))
                            .appFont(.headline, weight: .semibold)
                        ForEach(rows, id: \.titleKey) { row in
                            ComparisonFieldView(
                                title: L(row.titleKey),
                                names: names,
                                values: row.values.enumerated().map { index, value in formatted(value, unit: row.unit, loading: loading.contains(index)) },
                                same: loading.isEmpty && !row.values.contains { $0 != row.values.first! }
                            )
                        }
                    }
                }
                if loading.isEmpty, nutrition.allSatisfy({ $0.1.isEmpty }) {
                    if onlyDifferences && fields.isEmpty {
                        Text(L("compare_no_differences"))
                    } else if !onlyDifferences {
                        Text(L("nutrition_unavailable"))
                    }
                }
            }
        }
    }

    private func formatted(_ value: Double?, unit: String, loading: Bool) -> String {
        if loading { return L("compare_loading_details") }
        guard let value else { return L("compare_unreported") }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        if value > 0 && value < 0.001 {
            return "<\(formatter.string(from: NSNumber(value: 0.001)) ?? "0.001") \(unit)"
        }
        return "\(formatter.string(from: NSNumber(value: value)) ?? String(value)) \(unit)"
    }
}

private struct ComparisonFieldView: View {
    let title: String
    let names: [String]
    let values: [String]
    let same: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).appFont(.subheadline, weight: .semibold)
            if same, let first = values.first {
                Text(LF("compare_all", first))
            } else {
                ForEach(Array(zip(names, values).enumerated()), id: \.offset) { _, pair in
                    Text("\(pair.0): \(pair.1)")
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}
