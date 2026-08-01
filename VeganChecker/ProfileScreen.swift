import SwiftUI

struct ProfileScreen: View {
    @AppStorage(AllergenPreferences.selectedKeysKey) private var selectedAllergenStorage = ""
    @AppStorage(AllergenPreferences.strictModeKey) private var strictMode = false
    @AppStorage(WatchlistPreferences.additivesKey) private var watchedAdditivesStorage = ""
    @AppStorage(WatchlistPreferences.ingredientKeywordsKey) private var watchedKeywordsStorage = ""
    @State private var additiveInput = ""
    @State private var keywordInput = ""

    private var selectedKeys: Set<String> {
        AllergenPreferences.decodeSelectedKeys(selectedAllergenStorage)
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                infoCard
                strictModeCard
                watchlistCard
                Text(L("allergen_profile_catalog_title"))
                    .appFont(.headline, weight: .bold)
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

    private var watchlistCard: some View {
        profileCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(L("watchlist_title"))
                    .appFont(.headline, weight: .bold)
                Text(L("watchlist_message"))
                    .foregroundStyle(.secondary)

                Text(L("watchlist_additives_title"))
                    .appFont(.subheadline, weight: .bold)
                addRow(
                    placeholder: L("watchlist_additive_hint"),
                    input: $additiveInput,
                    action: addAdditive
                )
                watchChipList(
                    values: WatchlistPreferences.decode(watchedAdditivesStorage),
                    remove: removeAdditive
                )

                Text(L("watchlist_keywords_title"))
                    .appFont(.subheadline, weight: .bold)
                addRow(
                    placeholder: L("watchlist_keyword_hint"),
                    input: $keywordInput,
                    action: addKeyword
                )
                watchChipList(
                    values: WatchlistPreferences.decode(watchedKeywordsStorage),
                    remove: removeKeyword
                )
            }
        }
    }

    private func addRow(
        placeholder: String,
        input: Binding<String>,
        action: @escaping () -> Void
    ) -> some View {
        HStack(spacing: 8) {
            TextField(placeholder, text: input)
                .textFieldStyle(.roundedBorder)
                .onSubmit(action)
            Button(L("watchlist_add_action"), action: action)
                .buttonStyle(.borderedProminent)
                .tint(Color("AccentColor"))
        }
    }

    private func watchChipList(values: [String], remove: @escaping (String) -> Void) -> some View {
        if values.isEmpty {
            return AnyView(Text(L("watchlist_empty")).appFont(.caption).foregroundStyle(.secondary))
        }
        return AnyView(
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                ForEach(values, id: \.self) { value in
                    HStack(spacing: 4) {
                        Text(value)
                        Button {
                            remove(value)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(L("watchlist_remove_action"))
                    }
                    .appFont(.subheadline, weight: .semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Color("AccentColor").opacity(0.14))
                    .clipShape(Capsule())
                }
            }
        )
    }

    private var infoCard: some View {
        profileCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(L("allergen_profile_title"))
                    .appFont(.title3, weight: .bold)
                Text(L("allergen_profile_message"))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var strictModeCard: some View {
        profileCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(L("strict_mode_title"))
                    .appFont(.headline, weight: .bold)
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

    private func addAdditive() {
        let normalized = normalizeWatchedAdditive(additiveInput)
        guard !normalized.isEmpty else { return }
        var values = WatchlistPreferences.decode(watchedAdditivesStorage)
        if !values.contains(where: { normalizeWatchedAdditive($0) == normalized }) {
            values.append(normalized)
            watchedAdditivesStorage = WatchlistPreferences.encode(values)
        }
        additiveInput = ""
    }

    private func addKeyword() {
        let trimmed = keywordInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var values = WatchlistPreferences.decode(watchedKeywordsStorage)
        if !values.contains(where: { normalizeWatchedKeyword($0) == normalizeWatchedKeyword(trimmed) }) {
            values.append(trimmed)
            watchedKeywordsStorage = WatchlistPreferences.encode(values)
        }
        keywordInput = ""
    }

    private func removeAdditive(_ value: String) {
        watchedAdditivesStorage = WatchlistPreferences.encode(
            WatchlistPreferences.decode(watchedAdditivesStorage).filter { $0 != value }
        )
    }

    private func removeKeyword(_ value: String) {
        watchedKeywordsStorage = WatchlistPreferences.encode(
            WatchlistPreferences.decode(watchedKeywordsStorage).filter { $0 != value }
        )
    }
}
