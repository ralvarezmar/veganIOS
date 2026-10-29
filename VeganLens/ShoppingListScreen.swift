import SwiftUI
import SwiftData

struct ShoppingListScreen: View {
    @Query(sort: [SortDescriptor(\ShoppingListItem.addedAt, order: .reverse)]) private var items: [ShoppingListItem]
    @Environment(\.modelContext) private var modelContext

    let onSelectBarcode: (String) -> Void

    private var orderedItems: [ShoppingListItem] {
        items.filter { !$0.checked } + items.filter(\.checked)
    }

    var body: some View {
        Group {
            if items.isEmpty {
                ContentUnavailableView(
                    L("shopping_list_empty_title"),
                    systemImage: "cart",
                    description: Text(L("shopping_list_empty_message"))
                )
            } else {
                List {
                    ForEach(orderedItems) { item in
                        ShoppingListRow(
                            item: item,
                            onToggle: { toggleChecked(item) },
                            onOpen: { onSelectBarcode(item.barcode) }
                        )
                        .swipeActions {
                            Button(role: .destructive) {
                                remove(item)
                            } label: {
                                Label(L("shopping_list_remove_action"), systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(L("shopping_list_clear_checked")) {
                    clearChecked()
                }
                .disabled(!items.contains(where: \.checked))
            }
        }
        .navigationTitle(L("shopping_list_title"))
    }

    private func toggleChecked(_ item: ShoppingListItem) {
        item.checked.toggle()
        save()
    }

    private func remove(_ item: ShoppingListItem) {
        modelContext.delete(item)
        save()
    }

    private func clearChecked() {
        items.filter(\.checked).forEach { modelContext.delete($0) }
        save()
    }

    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("No se pudo actualizar la lista de la compra: \(error)")
        }
    }
}

private struct ShoppingListRow: View {
    let item: ShoppingListItem
    let onToggle: () -> Void
    let onOpen: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: item.checked ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.checked ? Color.accentColor : .secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(item.productName?.isEmpty == false ? item.productName! : item.barcode)
            .accessibilityValue(item.checked ? L("shopping_list_checked") : L("shopping_list_pending"))

            Button(action: onOpen) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.productName?.isEmpty == false ? item.productName! : item.barcode)
                        .appFont(.headline, weight: .semibold)
                        .strikethrough(item.checked)
                        .foregroundStyle(item.checked ? .secondary : .primary)
                        .lineLimit(2)
                    if let brand = item.brand, !brand.isEmpty {
                        Text(brand)
                            .appFont(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    if let verdict = item.verdict {
                        VerdictChip(status: VeganStatus(persisted: verdict))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
