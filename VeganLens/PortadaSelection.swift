import Foundation

let portadaCharacterNames = [
    "apple",
    "artichoke",
    "artichokehalf",
    "artichokes",
    "artichokesit",
    "artichokewink",
    "asparagus",
    "banana",
    "bellpepper",
    "blueberries",
    "broccoli",
    "carrot",
    "chili",
    "coconut",
    "corn",
    "dragonfruit",
    "eggplant",
    "kiwi",
    "kiwislice",
    "leaf",
    "leek",
    "mango",
    "melon",
    "mushrooms",
    "orange",
    "passionfruit",
    "peach",
    "peas",
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
    "portada_tip_16"
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
