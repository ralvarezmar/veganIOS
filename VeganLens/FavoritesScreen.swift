import SwiftUI
import SwiftData

struct FavoritesScreen: View {
    @Query(sort: [SortDescriptor(\FavoriteProduct.addedAt, order: .reverse)]) private var favorites: [FavoriteProduct]
    @Environment(\.modelContext) private var modelContext
    @State private var query = ""
    @State private var sortOrder: ListSortOrder = .mostRecent
    @State private var showingClearConfirmation = false

    let onSelectBarcode: (String) -> Void
    let onScanProduct: () -> Void

    private var displayedFavorites: [FavoriteProduct] {
        filterAndSortItems(
            favorites,
            query: query,
            sortOrder: sortOrder,
            productName: { $0.productName },
            brand: { $0.brand },
            barcode: { $0.barcode },
            timestamp: { $0.addedAt }
        )
    }

    var body: some View {
        List {
            if favorites.isEmpty {
                EmptyStateView(
                    icon: "star",
                    title: L("favorites_empty_title"),
                    message: L("favorites_empty_message"),
                    action: onScanProduct
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            } else if displayedFavorites.isEmpty {
                EmptyStateView(
                    icon: "star",
                    title: L("favorites_empty_title"),
                    message: L("favorites_no_matches"),
                    action: nil
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            } else {
                ForEach(displayedFavorites, id: \.barcode) { item in
                    Button {
                        onSelectBarcode(item.barcode)
                    } label: {
                        FavoriteRow(item: item)
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            delete(item)
                        } label: {
                            Label(L("delete_action"), systemImage: "trash")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $query, prompt: L("favorites_search_hint"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                sortMenu
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showingClearConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .disabled(favorites.isEmpty)
                .accessibilityLabel(L("clear_favorites"))
            }
        }
        .confirmationDialog(
            L("favorites_clear_confirmation_title"),
            isPresented: $showingClearConfirmation,
            titleVisibility: .visible
        ) {
            Button(L("clear_favorites"), role: .destructive) {
                clearFavorites()
            }
            Button(L("cancel"), role: .cancel) {}
        } message: {
            Text(L("favorites_clear_confirmation_message"))
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(L("favorites_title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var sortMenu: some View {
        Menu {
            Picker(L("sort_action"), selection: $sortOrder) {
                Text(L("sort_most_recent")).tag(ListSortOrder.mostRecent)
                Text(L("sort_name_az")).tag(ListSortOrder.nameAscending)
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
        .accessibilityLabel(L("sort_action"))
    }

    @MainActor
    private func delete(_ item: FavoriteProduct) {
        modelContext.delete(item)
        try? modelContext.save()
    }

    @MainActor
    private func clearFavorites() {
        for item in favorites {
            modelContext.delete(item)
        }
        try? modelContext.save()
    }
}

private struct FavoriteRow: View {
    let item: FavoriteProduct

    var body: some View {
        HStack(spacing: 14) {
            FavoriteThumbnail(imageURLString: item.imageURL)

            VStack(alignment: .leading, spacing: 5) {
                Text(item.productName?.isEmpty == false ? item.productName! : item.barcode)
                    .appFont(.headline, weight: .semibold)
                    .foregroundStyle(.primary)

                if let brand = item.brand, !brand.isEmpty {
                    Text(brand)
                        .appFont(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(item.addedAt.formatted(date: .abbreviated, time: .shortened))
                    .appFont(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            CapsuleBadge(text: L("favorites_chip_open_result"), tint: .green)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.secondary.opacity(0.10), lineWidth: 1)
        )
    }
}

private struct CapsuleBadge: View {
    let text: String
    let tint: Color

    var body: some View {
        Text(text)
            .appFont(.caption, weight: .semibold)
            .foregroundStyle(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(tint.opacity(0.12))
            .clipShape(Capsule())
    }
}

private struct FavoriteThumbnail: View {
    let imageURLString: String?

    var body: some View {
        Group {
            if let imageURLString, let url = URL(string: imageURLString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.quaternary)
            Image(systemName: "photo")
                .appFont(.title3)
                .foregroundStyle(.secondary)
        }
    }
}
