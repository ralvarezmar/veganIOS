import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.modelContext) private var modelContext
    @State private var showingClearCacheConfirmation = false

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
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "hand.raised")
                    }
                }
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
