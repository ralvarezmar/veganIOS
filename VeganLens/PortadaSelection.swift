import Foundation

let portadaCharacterNames = [
    "apple",
    "artichoke",
    "artichokehalf",
    "artichokes",
    "artichokesit",
    "artichokewink",
    "avocado",
    "asparagus",
    "banana",
    "bellpepper",
    "blueberries",
    "broccoli",
    "carrot",
    "cherries",
    "chili",
    "coconut",
    "corn",
    "dragonfruit",
    "eggplant",
    "grapes",
    "kiwi",
    "lemon",
    "kiwislice",
    "leaf",
    "mango",
    "melon",
    "mushrooms",
    "orange",
    "passionfruit",
    "peach",
    "peas",
    "pear",
    "pineapple",
    "plum",
    "pomegranate",
    "potato",
    "pumpkin",
    "purpleartichoke",
    "radishes",
    "redcabbage",
    "redonion",
    "strawberries",
    "strawberry",
    "sweetpotato",
    "tofu",
    "watermelon",
    "zucchini"
]

enum EmptyStateMascots {
    static let history = "carrot"
    static let favorites = "strawberry"
    static let search = "kiwi"
    static let onboarding = "broccoli"

    static let all = [history, favorites, search, onboarding]
}

let portadaTipKeys = [
    "portada_tip_01",
    "portada_tip_02",
    "portada_tip_03",
    "portada_tip_04",
    "portada_tip_05",
    "portada_tip_06",
    "portada_tip_07",
    "portada_tip_08",
    "portada_tip_09",
    "portada_tip_10",
    "portada_tip_11",
    "portada_tip_12",
    "portada_tip_13",
    "portada_tip_14",
    "portada_tip_15",
    "portada_tip_16",
    "portada_tip_17",
    "portada_tip_18",
    "portada_tip_19",
    "portada_tip_20",
    "portada_tip_21",
    "portada_tip_22",
    "portada_tip_23",
    "portada_tip_24",
    "portada_tip_25",
    "portada_tip_26",
    "portada_tip_27",
    "portada_tip_28",
    "portada_tip_29",
    "portada_tip_30"
]

func selectPortadaCharacter(
    previous: String?,
    randomIndex: (Int) -> Int = { upperBound in
        Int.random(in: 0..<upperBound)
    }
) -> String {
    let candidates = portadaCharacterNames.filter { $0 != previous }
    return candidates[randomIndex(candidates.count)]
}

func selectPortadaTip(
    previous: Int?,
    randomIndex: (Int) -> Int = { upperBound in
        Int.random(in: 0..<upperBound)
    }
) -> Int {
    let candidates = portadaTipKeys.indices.filter { $0 != previous }
    return candidates[randomIndex(candidates.count)]
}
