import SwiftUI

struct VerdictChip: View {
    let status: VeganStatus
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafePalette = false

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(veganVerdictColor(for: status, colorblindSafe: colorblindSafePalette))
                .frame(width: 8, height: 8)
            Text(verdictLabel(for: status))
                .appFont(.caption, weight: .semibold)
        }
        .foregroundStyle(veganVerdictColor(for: status, colorblindSafe: colorblindSafePalette))
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(
            veganVerdictColor(for: status, colorblindSafe: colorblindSafePalette)
                .opacity(0.12)
        )
        .clipShape(Capsule())
    }
}

struct VerdictFilterControls: View {
    @Binding var selectedVerdicts: Set<VeganStatus>
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafePalette = false

    private let statuses: [VeganStatus] = [.vegan, .maybe, .notVegan, .unknown]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(statuses, id: \.persistedValue) { status in
                    let isSelected = selectedVerdicts.contains(status)
                    Button {
                        if isSelected {
                            selectedVerdicts.remove(status)
                        } else {
                            selectedVerdicts.insert(status)
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(
                                    veganVerdictColor(
                                        for: status,
                                        colorblindSafe: colorblindSafePalette
                                    )
                                )
                                .frame(width: 8, height: 8)
                            Text(verdictFilterLabel(for: status))
                                .appFont(.caption, weight: .semibold)
                        }
                        .foregroundStyle(isSelected ? .white : .primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .strokeBorder(Color.secondary.opacity(isSelected ? 0 : 0.25), lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
            .padding(.horizontal, 1)
        }
    }
}

func verdictFilterLabel(for status: VeganStatus) -> String {
    switch status {
    case .vegan:
        return L("filter_verdict_vegan")
    case .maybe:
        return L("filter_verdict_maybe")
    case .notVegan:
        return L("filter_verdict_not_vegan")
    case .unknown:
        return L("filter_verdict_unknown")
    }
}

func verdictLabel(for status: VeganStatus) -> String {
    switch status {
    case .vegan:
        return L("share_verdict_apto")
    case .notVegan:
        return L("share_verdict_no_apto")
    case .maybe:
        return L("share_verdict_dudoso")
    case .unknown:
        return L("share_verdict_sin_datos")
    }
}
