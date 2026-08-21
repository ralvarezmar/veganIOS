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

func analyzePhotoIngredients(_ text: String) -> PhotoIngredientAnalysis {
    var animalIngredients: [String] = []
    var animalAdditives: [String] = []
    var unrecognized: [String] = []
    var recognizedIngredientCount = 0
    var traceWarning = false

    for rawSegment in ingredientSegments(text) {
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

        if containsAnimalIngredient(rawSegment) {
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
        reasonSource = .unrecognizedIngredient
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
    "oliva", "olive", "azeitona",
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
    "aroma", "flavor", "arome"
]

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
        matchesPhotoLexeme(lexeme, normalized: normalized, tokens: tokens)
    }
    let hasFunctionDescriptor = photoFunctionDescriptorLexemes.contains { lexeme in
        matchesPhotoLexeme(lexeme, normalized: normalized, tokens: tokens)
    }
    return hasPlantSource || (hasFunctionDescriptor && hasKnownNonAnimalAdditive)
}

private func isPhotoFunctionDescriptorOnly(_ label: String) -> Bool {
    let normalized = normalizeIngredientSegment(label)
    let tokens = normalized.components(separatedBy: CharacterSet.letters.inverted)
        .filter { !$0.isEmpty }
    let hasPlantSource = photoPlantSourceLexemes.contains { lexeme in
        matchesPhotoLexeme(lexeme, normalized: normalized, tokens: tokens)
    }
    let hasFunctionDescriptor = photoFunctionDescriptorLexemes.contains { lexeme in
        matchesPhotoLexeme(lexeme, normalized: normalized, tokens: tokens)
    }
    return hasFunctionDescriptor && !hasPlantSource
}

private func matchesPhotoLexeme(
    _ lexeme: String,
    normalized: String,
    tokens: [String]
) -> Bool {
    if lexeme.contains(" ") {
        return normalized == lexeme ||
            normalized.hasPrefix("\(lexeme) ") ||
            normalized.hasSuffix(" \(lexeme)") ||
            normalized.contains(" \(lexeme) ")
    }
    return tokens.contains(lexeme)
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
