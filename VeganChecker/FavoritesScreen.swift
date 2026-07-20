import SwiftUI
import SwiftData

struct FavoritesScreen: View {
    @Query(sort: [SortDescriptor(\FavoriteProduct.addedAt, order: .reverse)]) private var favorites: [FavoriteProduct]

    let onSelectBarcode: (String) -> Void
    let onScanProduct: () -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if favorites.isEmpty {
                    EmptyStateView(
                        icon: "star",
                        title: L("favorites_empty_title"),
                        message: L("favorites_empty_message"),
                        action: onScanProduct
                    )
                } else {
                    ForEach(favorites, id: \.barcode) { item in
                        Button {
                            onSelectBarcode(item.barcode)
                        } label: {
                            FavoriteRow(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(L("favorites_title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct FavoriteRow: View {
    let item: FavoriteProduct

    var body: some View {
        HStack(spacing: 14) {
            FavoriteThumbnail(imageURLString: item.imageURL)

            VStack(alignment: .leading, spacing: 5) {
                Text(item.productName?.isEmpty == false ? item.productName! : item.barcode)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                if let brand = item.brand, !brand.isEmpty {
                    Text(brand)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(item.addedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
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
            .font(.caption.weight(.semibold))
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
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
}
