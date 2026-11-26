import Foundation
import SwiftData

struct CacheEntryMetadata: Equatable {
    let barcode: String
    let cachedAt: Date
}

enum CacheAgeUnit: Equatable {
    case seconds
    case minute
    case minutes
    case hour
    case hours
    case day
    case days
}

struct CacheAge: Equatable {
    let value: Int
    let unit: CacheAgeUnit
}

func cacheAge(from date: Date, now: Date = Date()) -> CacheAge {
    let seconds = max(0, Int(now.timeIntervalSince(date)))
    if seconds < 60 {
        return CacheAge(value: seconds, unit: .seconds)
    }

    let minutes = seconds / 60
    if minutes < 60 {
        return CacheAge(value: minutes, unit: minutes == 1 ? .minute : .minutes)
    }

    let hours = minutes / 60
    if hours < 24 {
        return CacheAge(value: hours, unit: hours == 1 ? .hour : .hours)
    }

    let days = hours / 24
    return CacheAge(value: days, unit: days == 1 ? .day : .days)
}

func cacheBarcodesToEvict(
    entries: [CacheEntryMetadata],
    limit: Int = 100,
    protectedBarcodes: Set<String> = []
) -> Set<String> {
    guard limit >= 0, entries.count > limit else { return [] }
    let excess = entries.count - limit
    return Set(
        entries
            .filter { !protectedBarcodes.contains($0.barcode) }
            .sorted { $0.cachedAt < $1.cachedAt }
            .prefix(excess)
            .map(\.barcode)
    )
}

@MainActor
func storeCachedProduct(_ product: Product, source: ProductSource, barcode: String, in context: ModelContext) {
    do {
        let descriptor = FetchDescriptor<CachedProduct>(predicate: #Predicate { $0.barcode == barcode })
        let encoded = try JSONEncoder().encode(product)
        if let existing = try context.fetch(descriptor).first {
            existing.productData = encoded
            existing.sourceName = source.rawValue
            existing.cachedAt = Date()
        } else {
            context.insert(CachedProduct(barcode: barcode, productData: encoded, sourceName: source.rawValue, cachedAt: Date()))
        }
        let entries = try context.fetch(FetchDescriptor<CachedProduct>())
        let pinned = Set(try context.fetch(FetchDescriptor<FavoriteProduct>()).map(\.barcode))
            .union(try context.fetch(FetchDescriptor<ShoppingListItem>()).map(\.barcode))
        let evicted = cacheBarcodesToEvict(
            entries: entries.map { CacheEntryMetadata(barcode: $0.barcode, cachedAt: $0.cachedAt) },
            protectedBarcodes: pinned
        )
        entries.filter { evicted.contains($0.barcode) }.forEach(context.delete)
        try context.save()
    } catch {
        print("No se pudo guardar la caché: \(error)")
    }
}

/// Fetches and stores the shopping-list products that have no usable offline copy yet.
@MainActor
func prepareShoppingListOffline(barcodes: [String], service: OpenFactsService, in context: ModelContext) async {
    var seen = Set<String>()
    for barcode in barcodes where seen.insert(barcode).inserted {
        guard !Task.isCancelled else { return }
        if case .success(let fetched) = await service.fetchProduct(barcode: barcode) {
            storeCachedProduct(fetched.product, source: fetched.source, barcode: barcode, in: context)
        }
    }
}

func savedShoppingSnapshotBarcodes(_ cached: [CachedProduct]) -> Set<String> {
    Set(cached.filter { (try? JSONDecoder().decode(Product.self, from: $0.productData))?.hasUsefulData == true }.map(\.barcode))
}
