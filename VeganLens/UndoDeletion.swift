import SwiftUI
import SwiftData

struct DeletedScanSnapshot {
    let barcode: String
    let productName: String?
    let brand: String?
    let imageURL: String?
    let timestamp: Date
    let verdict: String?
    let category: String?
}

struct DeletedFavoriteSnapshot {
    let barcode: String
    let productName: String?
    let brand: String?
    let imageURL: String?
    let addedAt: Date
    let verdict: String?
    let category: String?
}

func makeScanRecord(from snapshot: DeletedScanSnapshot) -> ScanRecord {
    ScanRecord(
        barcode: snapshot.barcode,
        productName: snapshot.productName,
        brand: snapshot.brand,
        imageURL: snapshot.imageURL,
        timestamp: snapshot.timestamp,
        verdict: snapshot.verdict,
        category: snapshot.category
    )
}

func makeFavoriteProduct(from snapshot: DeletedFavoriteSnapshot) -> FavoriteProduct {
    FavoriteProduct(
        barcode: snapshot.barcode,
        productName: snapshot.productName,
        brand: snapshot.brand,
        imageURL: snapshot.imageURL,
        addedAt: snapshot.addedAt,
        verdict: snapshot.verdict,
        category: snapshot.category
    )
}

struct UndoBanner: View {
    let message: String
    let actionLabel: String
    let onUndo: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Text(message)
                .appFont(.subheadline)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(actionLabel, action: onUndo)
                .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.16), radius: 8, y: 3)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}
