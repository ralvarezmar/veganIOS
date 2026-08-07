import Foundation

enum PalmOilStatus {
    case present
    case maybe
    case free
}

func palmOilStatus(_ tags: [String]?) -> PalmOilStatus? {
    let normalized = Set((tags ?? []).map { $0.lowercased() })
    if normalized.contains("en:palm-oil") {
        return .present
    }
    if normalized.contains("en:may-contain-palm-oil") {
        return .maybe
    }
    if normalized.contains("en:palm-oil-free") {
        return .free
    }
    return nil
}
