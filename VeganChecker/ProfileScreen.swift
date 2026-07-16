import SwiftUI

struct ProfileScreen: View {
    @AppStorage(AllergenPreferences.selectedKeysKey) private var selectedAllergenStorage = ""
    @AppStorage(AllergenPreferences.strictModeKey) private var strictMode = false

    private var selectedKeys: Set<String> {
        AllergenPreferences.decodeSelectedKeys(selectedAllergenStorage)
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                infoCard
                strictModeCard
                Text(L("allergen_profile_catalog_title"))
                    .font(.headline.bold())
                    .padding(.horizontal, 4)

                ForEach(AllergenCatalog.options) { option in
                    toggleRow(
                        title: L(option.labelKey),
                        isOn: selectedKeys.contains(option.key),
                        onToggle: { enabled in
                            updateSelectedKeys(for: option.key, enabled: enabled)
                        }
                    )
                }
            }
            .padding(20)
        }
        .navigationTitle(L("profile_title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var infoCard: some View {
        profileCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(L("allergen_profile_title"))
                    .font(.title3.bold())
                Text(L("allergen_profile_message"))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var strictModeCard: some View {
        profileCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(L("strict_mode_title"))
                    .font(.headline.bold())
                Text(L("strict_mode_description"))
                    .foregroundStyle(.secondary)

                Toggle("", isOn: $strictMode)
                    .tint(Color("AccentColor"))
                    .labelsHidden()
            }
        }
    }

    private func toggleRow(title: String, isOn: Bool, onToggle: @escaping (Bool) -> Void) -> some View {
        profileCard {
            HStack(spacing: 16) {
                Text(title)
                Spacer()
                Toggle("", isOn: Binding(get: { isOn }, set: onToggle))
                    .labelsHidden()
            }
        }
    }

    private func profileCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(Color.secondary.opacity(0.10), lineWidth: 1)
            )
    }

    private func updateSelectedKeys(for key: String, enabled: Bool) {
        var newValue = selectedKeys
        if enabled {
            newValue.insert(key)
        } else {
            newValue.remove(key)
        }
        selectedAllergenStorage = AllergenPreferences.encodeSelectedKeys(newValue)
    }
}
