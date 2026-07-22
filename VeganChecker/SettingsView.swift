import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.modelContext) private var modelContext
    @State private var showingClearCacheConfirmation = false
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafePalette = false
    @AppStorage(AccessibilityPreferences.textSizeKey) private var textSize = AccessibilityTextSize.normal.rawValue
    @AppStorage(AccessibilityPreferences.highLegibilityFontKey) private var highLegibilityFont = false

    private let privacyURL = URL(string: "https://ralvarezmar.github.io/veganIOS/")!

    var body: some View {
        List {
            Section {
                Toggle(L("accessibility_colorblind_title"), isOn: $colorblindSafePalette)
                    .accessibilityIdentifier("accessibility-colorblind-toggle")

                Toggle(L("accessibility_font_title"), isOn: $highLegibilityFont)
                    .accessibilityIdentifier("accessibility-font-toggle")

                Picker(L("accessibility_text_size_title"), selection: $textSize) {
                    Text(L("accessibility_text_size_normal"))
                        .tag(AccessibilityTextSize.normal.rawValue)
                    Text(L("accessibility_text_size_large"))
                        .tag(AccessibilityTextSize.large.rawValue)
                    Text(L("accessibility_text_size_extra_large"))
                        .tag(AccessibilityTextSize.extraLarge.rawValue)
                }
                .accessibilityIdentifier("accessibility-text-size-picker")
            } header: {
                Text(L("accessibility_title"))
            } footer: {
                Text(L("accessibility_description"))
            }

            Section {
                Button {
                    openURL(privacyURL)
                } label: {
                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(L("privacy_policy_title"))
                            Text(L("privacy_policy_description"))
                                .appFont(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "hand.raised")
                    }
                }
                .accessibilityIdentifier("privacy-policy-row")
            } header: {
                Text(L("privacy_section_title"))
            }

            Section {
                Button(role: .destructive) {
                    showingClearCacheConfirmation = true
                } label: {
                    Label(L("clear_cache"), systemImage: "trash")
                }
            } header: {
                Text(L("cache_section_title"))
            }
        }
        .navigationTitle(L("settings_title"))
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            L("clear_cache_confirmation"),
            isPresented: $showingClearCacheConfirmation,
            titleVisibility: .visible
        ) {
            Button(L("clear_cache"), role: .destructive, action: clearCache)
            Button(L("cancel"), role: .cancel) {}
        }
    }

    private func clearCache() {
        do {
            let cachedProducts = try modelContext.fetch(FetchDescriptor<CachedProduct>())
            cachedProducts.forEach(modelContext.delete)
            try modelContext.save()
        } catch {
            print("No se pudo borrar la caché: \(error)")
        }
    }
}
