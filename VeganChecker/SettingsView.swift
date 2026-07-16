import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) private var openURL

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
        }
        .navigationTitle(L("settings_title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
