import SwiftUI

struct CompareView: View {
    @Environment(\.dismiss) private var dismiss

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
            }
            .navigationTitle(L("compare_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L("back")) { dismiss() }
                }
            }
        }
    }
}
