import Foundation

enum PhotoVeganStatus: Equatable {
    case notVegan
    case vegan
    case review
}

enum PhotoReasonSource: Equatable {
    case animalIngredient
    case animalAdditive
    case allPlantRecognized
    case unrecognizedIngredient
    case languageNotRecognized
}

enum PhotoLexemeMatchMode {
    case tokenExact
    case tokenPrefix
    case tokenContains
}

enum PhotoCulpritKind: Equatable {
    case animalIngredient
    case animalAdditive
}

struct PhotoCulprit: Equatable {
    let label: String
    let kind: PhotoCulpritKind
}

struct PhotoIngredientAnalysis: Equatable {
    let status: PhotoVeganStatus
    let reasonSource: PhotoReasonSource
    let culprits: [PhotoCulprit]
    let unrecognizedSegments: [String]
    let traceWarning: Bool
}

func analyzePhotoIngredients(
    _ text: String,
    preferredLanguage: String? = nil
) -> PhotoIngredientAnalysis {
    var animalIngredients: [String] = []
    var animalAdditives: [String] = []
    var unrecognized: [String] = []
    var recognizedIngredientCount = 0
    let section = extractPhotoIngredientSection(
        text,
        preferredLanguage: preferredLanguage ?? Locale.current.languageCode
    )
    var traceWarning = containsTraceWarning("\(section.ingredientsText) \(section.trailingText)")

    for rawSegment in ingredientSegments(section.ingredientsText) {
        if containsTraceWarning(rawSegment) {
            traceWarning = true
            continue
        }

        guard let label = cleanPhotoIngredientLabel(rawSegment) else {
            continue
        }
        let additiveCodes = findPhotoAdditiveCodes(in: rawSegment)

        if !additiveCodes.isEmpty {
            var segmentRecognized = true
            var segmentHasNonPlantAdditive = false
            for code in additiveCodes {
                switch additiveEntry(for: code)?.info.origin {
                case .animal:
                    appendUnique(code, to: &animalAdditives)
                    segmentHasNonPlantAdditive = true
                case .uncertain, .unknown, nil:
                    appendUnique(code, to: &unrecognized)
                    segmentRecognized = false
                    segmentHasNonPlantAdditive = true
                case .plant, .synthetic:
                    break
                }
            }

            let withoutCodes = rawSegment.replacingOccurrences(
                of: #"(?i)(?<![a-z0-9])e\s?-?\d{3,4}[a-z]*(?![a-z0-9])"#,
                with: " ",
                options: NSString.CompareOptions.regularExpression
            )
            let remainder = cleanPhotoIngredientLabel(withoutCodes)
            let hasKnownNonAnimalAdditive = additiveCodes.contains {
                guard let origin = additiveEntry(for: $0)?.info.origin else { return false }
                return origin == .plant || origin == .synthetic
            }
            if let remainder,
               !(segmentHasNonPlantAdditive && isPhotoFunctionDescriptorOnly(remainder)),
               !isRecognizedPhotoPlantOrNeutral(
                remainder,
                hasKnownNonAnimalAdditive: hasKnownNonAnimalAdditive
               ) {
                appendUnique(remainder, to: &unrecognized)
                segmentRecognized = false
            }
            if segmentRecognized {
                recognizedIngredientCount += 1
            }
            continue
        }

        if containsPhotoAnimalIngredient(rawSegment) {
            appendUnique(label, to: &animalIngredients)
            recognizedIngredientCount += 1
        } else if isRecognizedPhotoPlantOrNeutral(label) {
            recognizedIngredientCount += 1
        } else {
            appendUnique(label, to: &unrecognized)
        }
    }

    let culprits = animalIngredients.map {
        PhotoCulprit(label: $0, kind: .animalIngredient)
    } + animalAdditives.map {
        PhotoCulprit(label: $0, kind: .animalAdditive)
    }
    let reasonSource: PhotoReasonSource
    if !animalIngredients.isEmpty {
        reasonSource = .animalIngredient
    } else if !animalAdditives.isEmpty {
        reasonSource = .animalAdditive
    } else if !unrecognized.isEmpty || recognizedIngredientCount == 0 {
        reasonSource = !section.hasSupportedHeader &&
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            recognizedIngredientCount == 0
            ? .languageNotRecognized
            : .unrecognizedIngredient
    } else {
        reasonSource = .allPlantRecognized
    }
    let status: PhotoVeganStatus
    if !animalIngredients.isEmpty || !animalAdditives.isEmpty {
        status = .notVegan
    } else if !unrecognized.isEmpty || recognizedIngredientCount == 0 {
        status = .review
    } else {
        status = .vegan
    }

    return PhotoIngredientAnalysis(
        status: status,
        reasonSource: reasonSource,
        culprits: culprits,
        unrecognizedSegments: unrecognized,
        traceWarning: traceWarning
    )
}

struct PhotoIngredientSection {
    let ingredientsText: String
    let trailingText: String
    let hasSupportedHeader: Bool
}

private struct PhotoHeaderMatch {
    let start: Int
    let end: Int
    let languages: Set<String>
}

private func extractPhotoIngredientSection(
    _ text: String,
    preferredLanguage: String?
) -> PhotoIngredientSection {
    let headerPattern = #"(?i)(?<!\p{L})(ingredientes|ingredients|ingrédients|ingredienti|zutaten|inhaltsstoffe|composición|composicion|composition|composizione|composição|composicao)(?!\p{L})\s*:?\s*"#
    let markerPattern = #"(?i)(puede contener|pode conter|may contain|peut contenir|puo contenere|kann spuren|spuren von|trazas? de|traces? (?:of|de)|vestigios de|tracos de|informaci[oó]n nutricional|informa[cç][aã]o nutricional|valeurs? nutritionnelles?|n[aä]hrwerte|valori nutrizionali|nutrition information|nutrition facts|best before|conservar|consumir preferentemente|mindestens haltbar|zu verbrauchen bis|à consommer|a consommer|da consumarsi|validade|peso neto|poids net|net weight|nettogewicht|peso netto|\b\d+\s*(?:kj|kcal)\b)"#
    guard let headerRegex = try? NSRegularExpression(pattern: headerPattern),
          let markerRegex = try? NSRegularExpression(pattern: markerPattern) else {
        return PhotoIngredientSection(
            ingredientsText: text,
            trailingText: "",
            hasSupportedHeader: false
        )
    }

    let fullRange = NSRange(text.startIndex..., in: text)
    let headers = headerRegex.matches(in: text, range: fullRange).compactMap { match -> PhotoHeaderMatch? in
        guard let headerRange = Range(match.range(at: 1), in: text) else { return nil }
        let header = String(text[headerRange]).lowercased()
        let languages: Set<String>
        switch header {
        case "ingredientes": languages = ["es", "pt"]
        case "ingredients": languages = ["en", "fr"]
        case "ingrédients": languages = ["fr"]
        case "ingredienti": languages = ["it"]
        case "zutaten", "inhaltsstoffe": languages = ["de"]
        case "composición", "composicion": languages = ["es"]
        case "composition": languages = ["en", "fr"]
        case "composizione": languages = ["it"]
        case "composição", "composicao": languages = ["pt"]
        default: languages = []
        }
        return PhotoHeaderMatch(
            start: match.range.location,
            end: match.range.location + match.range.length,
            languages: languages
        )
    }
    let firstMarkerStart = markerRegex.firstMatch(in: text, range: fullRange)?.range.location ?? text.utf16.count
    guard !headers.isEmpty else {
        let ingredientsEnd = String.Index(utf16Offset: firstMarkerStart, in: text)
        return PhotoIngredientSection(
            ingredientsText: String(text[..<ingredientsEnd]),
            trailingText: String(text[ingredientsEnd...]),
            hasSupportedHeader: false
        )
    }

    let language = (preferredLanguage ?? "").lowercased()
        .split(separator: "-", omittingEmptySubsequences: true).first
        .map(String.init) ?? ""
    let selected = headers.first { $0.languages.contains(language) } ?? headers[0]
    let nextHeaderStart = headers.first { $0.start > selected.start }?.start ?? text.utf16.count
    let afterHeader = NSRange(location: selected.end, length: text.utf16.count - selected.end)
    let markerAfterHeader = markerRegex.firstMatch(in: text, range: afterHeader)?.range.location ?? text.utf16.count
    let end = min(nextHeaderStart, markerAfterHeader)
    let ingredientsStart = String.Index(utf16Offset: selected.end, in: text)
    let ingredientsEnd = String.Index(utf16Offset: end, in: text)
    let trailingStart = ingredientsEnd
    return PhotoIngredientSection(
        ingredientsText: String(text[ingredientsStart..<ingredientsEnd]),
        trailingText: String(text[trailingStart...]),
        hasSupportedHeader: true
    )
}

private let photoPlantSourceLexemes: Set<String> = [
    "agua", "water", "wasser", "eau", "acqua",
    "sal", "salt", "salz", "sel", "sale",
    "azucar", "sugar", "zucker", "sucre", "zucchero", "acucar",
    "harina", "flour", "mehl", "weizenmehl", "farine", "farina",
    "trigo", "wheat", "weizen", "ble", "grano", "frumento",
    "arroz", "rice", "reis", "riz", "riso",
    "maiz", "corn", "mais",
    "avena", "oat", "oats", "hafer", "avoine", "aveia",
    "centeno", "rye", "roggen", "seigle", "segale", "centeio",
    "cebada", "barley", "gerste", "orge", "orzo", "cevada",
    "almidon", "starch", "starke", "amidon", "amido",
    "aceite", "oil", "oleo", "ol", "oel", "huile", "olio",
    "girasol", "sunflower", "sonnenblume", "tournesol", "girasole", "girassol",
    "oliva", "olive", "aceituna", "azeitona", "granada", "pomegranate", "granatapfel",
    "melograno", "grenade", "zumo", "juice", "saft", "jus", "succo", "suco",
    "canola", "colza", "rapeseed", "raps",
    "coco", "coconut", "kokos", "cocco",
    "soja", "soy", "soya",
    "cacahuete", "peanut", "erdnuss", "arachide", "amendoim",
    "almendra", "almond", "mandel", "amande", "mandorla",
    "anacardo", "cashew", "anacard", "noix de cajou",
    "avellana", "hazelnut", "haselnuss", "noisette", "nocciola",
    "nuez", "walnut", "walnuss", "noix", "noce",
    "pistacho", "pistachio", "pistazie", "pistache", "pistacchio",
    "cacao", "cocoa", "kakao",
    "chocolate", "chocolat", "cioccolato",
    "levadura", "yeast", "hefe", "levure", "lievito", "fermento",
    "vinagre", "vinegar", "essig", "vinaigre", "aceto",
    "tomate", "tomato", "tomaten", "pomodoro",
    "patata", "potato", "kartoffel", "pomme de terre", "patate",
    "cebolla", "onion", "zwiebel", "oignon", "cipolla", "cebola",
    "ajo", "garlic", "knoblauch", "ail", "aglio", "alho",
    "zanahoria", "carrot", "karotte", "carotte", "carota", "cenoura",
    "pimiento", "bell pepper", "paprika", "poivron", "peperone", "pimento",
    "guisante", "pea", "erbse", "pois", "pisello", "ervilha",
    "lenteja", "lentil", "linse", "lentille", "lenticchia", "lentilha",
    "garbanzo", "chickpea", "kichererbse", "pois chiche", "cece", "grao",
    "frijol", "bean", "bohne", "haricot", "fagiolo", "feijao",
    "manteca de cacao", "cocoa butter", "kakaobutter", "beurre de cacao",
    "burro di cacao", "manteiga de cacau",
    "malta", "malt", "malz", "malto", "malte",
    "semola", "semolina", "griess", "semoule",
    "salvado", "bran", "kleie", "son", "crusca", "farelo",
    "dextrosa", "dextrose", "dextrosio",
    "glucosa", "glucose", "glukose", "glucosio", "glicose",
    "jarabe", "syrup", "sirup", "sirop", "sciroppo", "xarope",
    "sirope", "fibra", "fiber", "faser", "fibre",
    "maltodextrina", "maltodextrin", "maltodextrine", "maltodestrina",
    "bicarbonato", "bicarbonate", "natriumbicarbonat",
    "carbonato", "carbonate", "karbonat",
    "acido citrico", "citric acid", "zitronensaure", "acide citrique",
    "acido ascorbico", "ascorbic acid", "ascorbinsaure", "acide ascorbique",
    "citrato", "citrate", "citrat",
    "celulosa", "cellulose", "zellulose",
    "pectina", "pectin", "pektin", "pectine",
    "goma guar", "guar gum", "guarkernmehl", "gomme guar", "gomma di guar",
    "dioxido de silicio", "silicon dioxide", "siliciumdioxid",
    "dioxyde de silicium", "diossido di silicio",
    "proteina de guisante", "pea protein", "erbsenprotein",
    "proteine de pois", "proteina di pisello", "proteina de ervilha",
    "proteina de soja", "soy protein", "sojaprotein",
    "proteine de soja", "proteina di soia",
    "agar", "tapioca", "quinoa",
    "mijo", "millet", "hirse", "miglio", "milheto",
    "espelta", "spelt", "dinkel", "epeautre", "farro",
    "sesamo", "sesame", "sesam", "gergelim",
    "lino", "flax", "lein", "lin", "linho",
    "chia",
    "xantana", "xanthan gum", "xanthangummi", "gomme xanthane",
    "gomma xantana", "goma xantana",
    "garrofin", "locust bean gum", "johannisbrotkernmehl",
    "gomme de caroube", "gomma di carruba", "goma de alfarroba",
    "vainilla", "vanilla", "vanille", "vaniglia", "baunilha",
    "oregano", "basil", "basilikum", "basilic", "basilico", "manjericao",
    "pimienta", "pepper", "pfeffer", "poivre", "pepe", "pimenta",
    "extracto de vainilla", "vanilla extract", "vanilleextrakt",
    "extrait de vanille", "estratto di vaniglia", "extrato de baunilha"
]

private let photoFunctionDescriptorLexemes: Set<String> = [
    "colorante", "colour", "color", "farbstoff", "colorant",
    "acidulante", "acidity", "acido", "acid", "saure", "acide",
    "regulador", "regulator", "regulateur", "regolatore",
    "conservante", "preservative", "konservierung", "conservateur",
    "antioxidante", "antioxidant", "antioxidans", "antioxydant", "antiossidante",
    "emulgente", "emulsifier", "emulgator", "emulsifiant", "emulsionante",
    "espesante", "thickener", "verdickungsmittel", "epaississant", "addensante",
    "extracto", "extract", "extrakt", "extrait", "estratto",
    "lecitina", "lecithin", "lecithine",
    "fruta", "fruit", "obst", "fruits", "frutta",
    "vegetal", "vegetable", "gemuse", "legume", "verdura", "hortalica",
    "semilla", "seed", "samen", "graine", "seme",
    "especia", "spice", "gewurz", "epice", "spezia", "especiaria",
    "aroma", "flavor", "arome",
    "backtriebmittel", "gasificante", "agente lievitante", "levedante",
    "poudre a lever", "levure chimique", "raising agent"
]

private let photoPlantContainmentLexemes: Set<String> = [
    "salz", "zucker", "mehl", "sonnenblume"
]

private let photoPlantPrefixLexemes: Set<String> = ["granatapfel"]

private let photoAnimalLexemeModes: [String: PhotoLexemeMatchMode] = [
    "milch": .tokenContains, "milk": .tokenContains, "leche": .tokenContains,
    "lait": .tokenContains, "latte": .tokenContains, "nata": .tokenExact,
    "sahne": .tokenContains, "cream": .tokenContains, "creme": .tokenContains,
    "panna": .tokenContains, "crema": .tokenContains, "butter": .tokenContains,
    "mantequilla": .tokenPrefix, "beurre": .tokenContains, "burro": .tokenContains,
    "obers": .tokenContains, "rahm": .tokenContains, "molke": .tokenPrefix,
    "whey": .tokenPrefix, "lactos": .tokenPrefix, "laktos": .tokenPrefix,
    "lactosuero": .tokenPrefix,
    "casein": .tokenPrefix, "caseina": .tokenPrefix, "kasein": .tokenPrefix,
    "lactoglob": .tokenPrefix, "lactalb": .tokenPrefix, "queso": .tokenPrefix,
    "suero de leche": .tokenExact,
    "cheese": .tokenPrefix, "kase": .tokenContains, "fromage": .tokenPrefix,
    "formagg": .tokenPrefix, "parmesan": .tokenPrefix, "parmigian": .tokenPrefix,
    "mozzarella": .tokenPrefix, "cheddar": .tokenPrefix, "gouda": .tokenPrefix,
    "emmental": .tokenPrefix, "ovoalbum": .tokenPrefix, "ovoprodu": .tokenPrefix,
    "gelatin": .tokenPrefix, "gelatina": .tokenPrefix, "gelatine": .tokenPrefix,
    "miel": .tokenExact, "honey": .tokenExact, "honig": .tokenExact,
    "miele": .tokenExact, "carne": .tokenPrefix, "fleisch": .tokenContains,
    "viande": .tokenPrefix, "jamon": .tokenPrefix, "tocino": .tokenPrefix,
    "panceta": .tokenPrefix, "bacon": .tokenPrefix, "speck": .tokenPrefix,
    "schinken": .tokenContains, "pollo": .tokenPrefix, "huhn": .tokenPrefix,
    "poulet": .tokenPrefix, "chicken": .tokenPrefix, "cerdo": .tokenPrefix,
    "schwein": .tokenPrefix, "pork": .tokenPrefix, "porc": .tokenPrefix,
    "ternera": .tokenPrefix, "vacuno": .tokenPrefix, "beef": .tokenPrefix,
    "cordero": .tokenPrefix, "lamb": .tokenPrefix, "agnello": .tokenPrefix,
    "pavo": .tokenPrefix, "turkey": .tokenPrefix, "chorizo": .tokenPrefix,
    "salami": .tokenPrefix, "wurst": .tokenContains, "embutido": .tokenPrefix,
    "pescado": .tokenPrefix, "poisson": .tokenPrefix, "fisch": .tokenPrefix,
    "atun": .tokenPrefix, "thunfisch": .tokenPrefix, "thon": .tokenPrefix,
    "tuna": .tokenExact, "anchoa": .tokenPrefix, "anchois": .tokenPrefix,
    "sardin": .tokenPrefix, "gamba": .tokenPrefix, "camaron": .tokenPrefix,
    "shrimp": .tokenPrefix, "krill": .tokenPrefix, "krebstier": .tokenPrefix,
    "molusco": .tokenPrefix, "calamar": .tokenPrefix, "pulpo": .tokenPrefix,
    "marisco": .tokenPrefix, "seafood": .tokenPrefix, "surimi": .tokenPrefix,
    "salmon": .tokenPrefix, "lachs": .tokenPrefix, "saumon": .tokenPrefix,
    "bacalao": .tokenPrefix, "kabeljau": .tokenPrefix, "trucha": .tokenPrefix,
    "forelle": .tokenPrefix, "schmalz": .tokenContains, "saindoux": .tokenPrefix,
    "sebo": .tokenPrefix, "tallow": .tokenPrefix, "talg": .tokenPrefix,
    "suif": .tokenPrefix, "lard": .tokenPrefix, "lardo": .tokenPrefix,
    "carmin": .tokenPrefix, "karmin": .tokenPrefix, "cochinill": .tokenPrefix,
    "cochenill": .tokenPrefix, "cochineal": .tokenPrefix, "e120": .tokenExact,
    "carminico": .tokenPrefix, "shellac": .tokenPrefix, "schellack": .tokenPrefix,
    "goma laca": .tokenExact,
    "e904": .tokenExact, "albumin": .tokenPrefix, "albumina": .tokenPrefix,
    "lanolin": .tokenPrefix, "lanolina": .tokenPrefix, "cuajo": .tokenPrefix,
    "rennet": .tokenPrefix, "presure": .tokenPrefix, "labferment": .tokenPrefix,
    "chitin": .tokenPrefix, "quitina": .tokenPrefix,
    "manteca de cerdo": .tokenExact, "cera de abeja": .tokenExact,
    "beeswax": .tokenExact, "bienenwachs": .tokenExact,
    "cire d abeille": .tokenExact, "royal jelly": .tokenExact,
    "jalea real": .tokenExact, "gelee royale": .tokenExact,
    "propolis": .tokenExact, "e901": .tokenExact
]

private let photoAmbiguousAnimalLexemes: Set<String> = [
    "milch", "milk", "leche", "lait", "latte", "nata", "sahne", "cream",
    "creme", "panna", "crema", "butter", "mantequilla", "beurre", "burro",
    "obers", "rahm"
]

private let photoPlantQualifiers: Set<String> = [
    "coco", "coconut", "kokos", "almendra", "almend", "almond", "mandel",
    "amande", "soja", "soy", "soya", "avena", "oat", "hafer", "avoine",
    "arroz", "rice", "reis", "riz", "cacahuete", "cacahuet", "peanut",
    "erdnuss", "arachide", "cacao", "cocoa", "kakao", "karite", "shea",
    "anacardo", "cashew", "avellana", "hazelnut", "haselnuss", "nuez",
    "walnut", "nogal", "vegetal", "vegetale", "vegetabil", "pflanzlich",
    "vegan", "tofu", "seitan", "oliva", "olive", "girasol", "sunflower",
    "sonnenblume", "tournesol", "palma", "palm"
]

private func containsPhotoAnimalIngredient(_ segment: String) -> Bool {
    let normalized = normalizeIngredientSegment(segment)
    let tokens = normalized.components(separatedBy: CharacterSet.letters.inverted)
        .filter { !$0.isEmpty }
    let hasUnambiguousMatch = photoAnimalLexemeModes.contains { entry in
        !photoAmbiguousAnimalLexemes.contains(entry.key) &&
            matchesPhotoLexeme(
                entry.key,
                mode: entry.value,
                normalized: normalized,
                tokens: tokens
            )
    }
    let hasAmbiguousMatch = photoAnimalLexemeModes.contains { entry in
        photoAmbiguousAnimalLexemes.contains(entry.key) &&
            matchesPhotoLexeme(
                entry.key,
                mode: entry.value,
                normalized: normalized,
                tokens: tokens
            )
    }
    let hasPlantQualifier = photoPlantQualifiers.contains { normalized.contains($0) }
    let eggTokens: Set<String> = [
        "huevo", "huevos", "yema", "yemas", "ovoproducto", "egg", "eggs",
        "albumen", "ovalbumin", "ei", "eier", "eigelb", "eiklar", "vollei",
        "volleipulver", "eipulver", "trockenei", "huhnerei", "oeuf", "oeufs"
    ]
    return hasUnambiguousMatch || (hasAmbiguousMatch && !hasPlantQualifier) ||
        tokens.contains { eggTokens.contains($0) }
}

private func cleanPhotoIngredientLabel(_ rawSegment: String) -> String? {
    guard let cleaned = cleanFoodFactsLabel(rawSegment) else { return nil }
    let withoutQuantities = cleaned
        .replacingOccurrences(
            of: #"\b\d+(?:[.,]\d+)?\s*%?\b"#,
            with: " ",
            options: .regularExpression
        )
        .replacingOccurrences(of: "%", with: " ")
        .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
        .trimmingCharacters(in: .whitespacesAndNewlines)
    return withoutQuantities.isEmpty ? nil : cleanFoodFactsLabel(withoutQuantities)
}

private func isRecognizedPhotoPlantOrNeutral(
    _ label: String,
    hasKnownNonAnimalAdditive: Bool = false
) -> Bool {
    let normalized = normalizeIngredientSegment(label)
    let tokens = normalized.components(separatedBy: CharacterSet.letters.inverted)
        .filter { !$0.isEmpty }
    let hasPlantSource = photoPlantSourceLexemes.contains { lexeme in
        matchesPhotoLexeme(
            lexeme,
            mode: photoPlantLexemeMode(lexeme),
            normalized: normalized,
            tokens: tokens
        )
    }
    let hasFunctionDescriptor = photoFunctionDescriptorLexemes.contains { lexeme in
        matchesPhotoLexeme(
            lexeme,
            mode: .tokenExact,
            normalized: normalized,
            tokens: tokens
        )
    }
    return hasPlantSource || (hasFunctionDescriptor && hasKnownNonAnimalAdditive)
}

private func isPhotoFunctionDescriptorOnly(_ label: String) -> Bool {
    let normalized = normalizeIngredientSegment(label)
    let tokens = normalized.components(separatedBy: CharacterSet.letters.inverted)
        .filter { !$0.isEmpty }
    let hasPlantSource = photoPlantSourceLexemes.contains { lexeme in
        matchesPhotoLexeme(
            lexeme,
            mode: photoPlantLexemeMode(lexeme),
            normalized: normalized,
            tokens: tokens
        )
    }
    let hasFunctionDescriptor = photoFunctionDescriptorLexemes.contains { lexeme in
        matchesPhotoLexeme(
            lexeme,
            mode: .tokenExact,
            normalized: normalized,
            tokens: tokens
        )
    }
    return hasFunctionDescriptor && !hasPlantSource
}

private func photoPlantLexemeMode(_ lexeme: String) -> PhotoLexemeMatchMode {
    if photoPlantContainmentLexemes.contains(lexeme) {
        return .tokenContains
    }
    if photoPlantPrefixLexemes.contains(lexeme) {
        return .tokenPrefix
    }
    return .tokenExact
}

func matchesPhotoLexeme(
    _ lexeme: String,
    mode: PhotoLexemeMatchMode,
    normalized: String,
    tokens: [String]
) -> Bool {
    if lexeme.contains(" ") {
        return normalized == lexeme ||
            normalized.hasPrefix("\(lexeme) ") ||
            normalized.hasSuffix(" \(lexeme)") ||
            normalized.contains(" \(lexeme) ")
    }
    return tokens.contains { token in
        switch mode {
        case .tokenExact: return token == lexeme
        case .tokenPrefix: return token.hasPrefix(lexeme)
        case .tokenContains: return token.contains(lexeme)
        }
    }
}

private func findPhotoAdditiveCodes(in text: String) -> [String] {
    guard let regex = try? NSRegularExpression(
        pattern: #"(?i)(?<![a-z0-9])e\s?-?\d{3,4}[a-z]*(?![a-z0-9])"#
    ) else {
        return []
    }
    let range = NSRange(text.startIndex..., in: text)
    var codes: [String] = []
    for match in regex.matches(in: text, range: range) {
        guard let matchRange = Range(match.range, in: text) else { continue }
        let raw = String(text[matchRange])
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        appendUnique(canonicalPhotoAdditiveCode(raw), to: &codes)
    }
    return codes
}

private func canonicalPhotoAdditiveCode(_ rawCode: String) -> String {
    let normalized = normalizeAdditiveCode(rawCode)
    guard normalized.range(of: #"^E\d{3,4}[IVX]+$"#, options: .regularExpression) != nil else {
        return normalized
    }
    return normalized.replacingOccurrences(
        of: #"[IVX]+$"#,
        with: "",
        options: .regularExpression
    )
}

private func appendUnique(_ value: String, to values: inout [String]) {
    if !values.contains(value) {
        values.append(value)
    }
}
