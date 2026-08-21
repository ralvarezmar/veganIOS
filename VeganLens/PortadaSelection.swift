import Foundation

let portadaCharacterNames = [
    "apple",
    "banana",
    "blueberries",
    "broccoli",
    "carrot",
    "chili",
    "corn",
    "leaf",
    "mushrooms",
    "orange",
    "peas",
    "plum",
    "strawberries",
    "strawberry",
    "tofu"
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
