import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.modelContext) private var modelContext
    @State private var showingClearCacheConfirmation = false
    @State private var showingCredits = false
    @State private var showingMascotGallery = false
    @State private var versionTapCount = 0
    @State private var lastVersionTap: Date?
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafePalette = false
    @AppStorage(AccessibilityPreferences.textSizeKey) private var textSize = AccessibilityTextSize.normal.rawValue
    @AppStorage(AccessibilityPreferences.highLegibilityFontKey) private var highLegibilityFont = false

    private let privacyURL = URL(string: "https://ralvarezmar.github.io/veganIOS/")!

    var body: some View {
        List {
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

                Button {
                    showingCredits = true
                } label: {
                    Label {
                        Text(L("credits_title"))
                            .appFont(.body)
                    } icon: {
                        Image(systemName: "heart")
                    }
                }
                .accessibilityIdentifier("credits-row")
            } header: {
                Text(L("privacy_section_title"))
            }

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
                Button(role: .destructive) {
                    showingClearCacheConfirmation = true
                } label: {
                    Label(L("clear_cache"), systemImage: "trash")
                }
            } header: {
                Text(L("cache_section_title"))
            }

            Section {
                Text(versionText)
                    .appFont(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .contentShape(Rectangle())
                    .accessibilityIdentifier("mascot-gallery-version")
                    .accessibilityLabel(versionText)
                    .onTapGesture(perform: registerVersionTap)
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
        .alert(L("credits_title"), isPresented: $showingCredits) {
            Button(L("gallery_close"), role: .cancel) {}
        } message: {
            Text(L("credits_body"))
                .appFont(.body)
        }
        .sheet(isPresented: $showingMascotGallery) {
            MascotGalleryView()
        }
    }

    private var versionText: String {
        let info = Bundle.main.infoDictionary ?? [:]
        let version = info["CFBundleShortVersionString"] as? String ?? "?"
        let build = info["CFBundleVersion"] as? String ?? "?"
        return LF("gallery_version", L("app_name"), version, build)
    }

    private func registerVersionTap() {
        let now = Date()
        if let lastVersionTap, now.timeIntervalSince(lastVersionTap) > 2 {
            versionTapCount = 0
        }
        versionTapCount += 1
        lastVersionTap = now
        if versionTapCount == 7 {
            versionTapCount = 0
            lastVersionTap = nil
            showingMascotGallery = true
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
