import Foundation

let portadaCharacterNames = [
    "apple",
    "artichoke",
    "asparagus",
    "banana",
    "bellpepper",
    "blueberries",
    "broccoli",
    "carrot",
    "chili",
    "coconut",
    "corn",
    "kiwi",
    "kiwislice",
    "leaf",
    "leek",
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

func selectPortadaCharacter(
    previous: String?,
    randomIndex: (Int) -> Int = { upperBound in
        Int.random(in: 0..<upperBound)
    }
) -> String {
    let candidates = portadaCharacterNames.filter { $0 != previous }
    return candidates[randomIndex(candidates.count)]
}
