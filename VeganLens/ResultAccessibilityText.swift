import Foundation

func verdictAccessibilityText(
    headline: String,
    subtitle: String,
    explanation: String?,
    confidence: String? = nil
) -> String {
    [headline, subtitle, explanation?.isEmpty == false ? explanation : nil, confidence?.isEmpty == false ? confidence : nil]
        .compactMap { $0 }
        .joined(separator: ". ")
}
