import Foundation

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

let cacheTTLSeconds: TimeInterval = 60 * 24 * 60 * 60

func isCacheEntryExpired(
    cachedAt: Date,
    now: Date = Date(),
    ttl: TimeInterval = cacheTTLSeconds
) -> Bool {
    now.timeIntervalSince(cachedAt) > ttl
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
    limit: Int = 100
) -> Set<String> {
    guard limit >= 0, entries.count > limit else { return [] }
    return Set(
        entries
            .sorted { $0.cachedAt < $1.cachedAt }
            .prefix(entries.count - limit)
            .map(\.barcode)
    )
}
