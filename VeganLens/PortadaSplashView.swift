import SwiftUI

enum PortadaColors {
    static let background = Color(red: 0.992, green: 0.988, blue: 0.949)
    static let title = Color(red: 0.106, green: 0.369, blue: 0.125)
    static let tagline = Color(red: 0.192, green: 0.357, blue: 0.208)
}

struct PortadaSplashView: View {
    let character: String
    let onDismiss: () -> Void

    var body: some View {
        Button(action: onDismiss) {
            VStack(spacing: 16) {
                Image("portada_\(character)")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 240, maxHeight: 240)
                    .accessibilityLabel(L("portada_image_description"))

                Text(L("app_name"))
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(PortadaColors.title)

                Text(L("portada_tagline"))
                    .font(.title3)
                    .foregroundStyle(PortadaColors.tagline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(24)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(PortadaColors.background)
        .ignoresSafeArea()
        .accessibilityHint(L("portada_dismiss"))
        .task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            guard !Task.isCancelled else { return }
            onDismiss()
        }
    }
}
