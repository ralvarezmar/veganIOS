import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let action: (() -> Void)?

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .appIconFont(size: 28, weight: .semibold)
                .foregroundStyle(.green)
                .frame(width: 64, height: 64)
                .background(Color.green.opacity(0.14), in: Circle())

            Text(title)
                .appFont(.title2, weight: .bold)

            Text(message)
                .appFont(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if let action {
                Button(L("empty_scan_action"), action: action)
                    .buttonStyle(.borderedProminent)
                    .tint(Color("AccentColor"))
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.top, 64)
    }
}
