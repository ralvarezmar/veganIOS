import SwiftUI

func veganVerdictColor(for status: VeganStatus, colorblindSafe: Bool) -> Color {
    if colorblindSafe {
        switch status {
        case .vegan:
            return Color(red: 0x00 / 255, green: 0x72 / 255, blue: 0xB2 / 255)
        case .notVegan:
            return Color(red: 0xD5 / 255, green: 0x5E / 255, blue: 0x00 / 255)
        case .maybe:
            return Color(red: 0xE6 / 255, green: 0x9F / 255, blue: 0x00 / 255)
        case .unknown:
            return Color(red: 0x6B / 255, green: 0x72 / 255, blue: 0x80 / 255)
        }
    }

    switch status {
    case .vegan:
        return .green
    case .notVegan:
        return .red
    case .maybe:
        return .orange
    case .unknown:
        return Color(red: 0.45, green: 0.47, blue: 0.50)
    }
}
