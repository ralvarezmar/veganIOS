import Foundation

func verdictAccessibilityText(
    headline: String,
    subtitle: String,
    explanation: String?
) -> String {
    [headline, subtitle, explanation?.isEmpty == false ? explanation : nil]
        .compactMap { $0 }
        .joined(separator: ". ")
}
