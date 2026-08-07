import Foundation

struct AllergenOption: Identifiable {
    let key: String
    let labelKey: String
    let aliases: Set<String>

    var id: String { key }

    init(key: String, labelKey: String, aliases: Set<String> = []) {
        self.key = key
        self.labelKey = labelKey
        self.aliases = aliases.union([key])
    }

    func matches(_ tagStem: String) -> Bool {
        let normalizedStem = normalizeAllergenStem(tagStem)
        return normalizedStem == normalizeAllergenStem(key) ||
            aliases.contains { normalizedStem == normalizeAllergenStem($0) }
    }
}

enum AllergenCatalog {
    static let options: [AllergenOption] = [
        AllergenOption(key: "gluten", labelKey: "allergen_gluten"),
        AllergenOption(key: "crustaceans", labelKey: "allergen_crustaceans"),
        AllergenOption(key: "eggs", labelKey: "allergen_eggs"),
        AllergenOption(key: "fish", labelKey: "allergen_fish"),
        AllergenOption(key: "peanuts", labelKey: "allergen_peanuts"),
        AllergenOption(key: "soybeans", labelKey: "allergen_soybeans", aliases: ["soy", "soya", "soybeans"]),
        AllergenOption(key: "milk", labelKey: "allergen_milk"),
        AllergenOption(key: "nuts", labelKey: "allergen_nuts", aliases: ["tree-nuts", "tree_nuts", "nuts"]),
        AllergenOption(key: "celery", labelKey: "allergen_celery"),
        AllergenOption(key: "mustard", labelKey: "allergen_mustard"),
        AllergenOption(key: "sesame-seeds", labelKey: "allergen_sesame_seeds", aliases: ["sesame", "sesame-seeds", "sesame_seeds"]),
        AllergenOption(key: "sulphites", labelKey: "allergen_sulphites", aliases: ["sulphites", "sulfites"]),
        AllergenOption(key: "lupin", labelKey: "allergen_lupin"),
        AllergenOption(key: "molluscs", labelKey: "allergen_molluscs", aliases: ["molluscs", "mollusks"]),
    ]

    private static let byNormalizedStem: [String: AllergenOption] = {
        var map: [String: AllergenOption] = [:]
        for option in options {
            map[normalizeAllergenStem(option.key)] = option
            for alias in option.aliases {
                map[normalizeAllergenStem(alias)] = option
            }
        }
        return map
    }()

    static func optionForTagStem(_ tagStem: String) -> AllergenOption? {
        byNormalizedStem[normalizeAllergenStem(tagStem)]
    }

    static func selectedOptions(_ keys: Set<String>) -> [AllergenOption] {
        options.filter { keys.contains($0.key) }
    }
}

func normalizeAllergenStem(_ raw: String) -> String {
    let lowered = raw.lowercased()
    let strippedPrefix = lowered.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false).last.map(String.init) ?? lowered
    let unifiedSeparators = strippedPrefix
        .replacingOccurrences(of: "_", with: "-")
        .replacingOccurrences(of: " ", with: "-")
    return unifiedSeparators.trimmingCharacters(in: CharacterSet(charactersIn: "-").union(.whitespacesAndNewlines))
}

struct AllergenDisplayItem: Identifiable {
    let key: String?
    let label: String

    var id: String { key ?? label.lowercased() }
}

enum AllergenPreferences {
    static let selectedKeysKey = "selected_allergen_keys"
    static let strictModeKey = "strict_mode_enabled"

    static func decodeSelectedKeys(_ storage: String) -> Set<String> {
        Set(storage.split(separator: ",").map(String.init).filter { !$0.isEmpty })
    }

    static func encodeSelectedKeys(_ keys: Set<String>) -> String {
        keys.sorted().joined(separator: ",")
    }
}

func buildAllergenDisplayItems(tags: [String]) -> [AllergenDisplayItem] {
    tags.compactMap { tag in
        let stem = normalizeAllergenStem(tag)
        let option = AllergenCatalog.optionForTagStem(stem)
        let label = option.map { L($0.labelKey) } ?? cleanFoodFactsLabel(tag)
        guard let label else { return nil }
        return AllergenDisplayItem(key: option?.key, label: label)
    }
    .deduplicated()
}

func buildProfileAllergenMatches(
    product: Product,
    selectedKeys: Set<String>,
    strictMode: Bool
) -> [AllergenDisplayItem] {
    guard !selectedKeys.isEmpty else { return [] }
    let productTagKeys = (product.allergensTags ?? []).compactMap { tag in
        AllergenCatalog.optionForTagStem(tag)?.key
    }
    let traceKeys: [String]
    if strictMode {
        traceKeys = (product.ingredientsAnalysisTags ?? []).compactMap { tag in
            let normalized = normalizeAllergenStem(tag)
            return AllergenCatalog.options.first { option in
                option.matches(normalized) || option.aliases.contains { alias in
                    normalized.contains(normalizeAllergenStem(alias))
                }
            }?.key
        }
    } else {
        traceKeys = []
    }
    let matchedKeys = Set(productTagKeys).union(traceKeys).intersection(selectedKeys)
    return AllergenCatalog.selectedOptions(matchedKeys).map {
        AllergenDisplayItem(key: $0.key, label: L($0.labelKey))
    }
}

private extension Array where Element == AllergenDisplayItem {
    func deduplicated() -> [AllergenDisplayItem] {
        var seen = Set<String>()
        return filter { item in
            let key = item.key ?? item.label.lowercased()
            return seen.insert(key).inserted
        }
    }
}
