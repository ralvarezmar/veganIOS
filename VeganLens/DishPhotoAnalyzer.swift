import UIKit
import Vision

enum DishVeganHint: Equatable {
    case animal
    case plant
}

enum DishPortion: CaseIterable, Hashable {
    case small
    case normal
    case large

    var factor: Double {
        switch self {
        case .small: return 0.7
        case .normal: return 1.0
        case .large: return 1.4
        }
    }

    var localizationKey: String {
        switch self {
        case .small: return "dish_photo_portion_small"
        case .normal: return "dish_photo_portion_normal"
        case .large: return "dish_photo_portion_large"
        }
    }
}

enum DishFood: String, CaseIterable {
    case pizza
    case burger
    case hotDog = "hot_dog"
    case pasta
    case rice
    case bread
    case sandwich
    case sushi
    case soup
    case fries
    case salad
    case vegetable
    case fruit
    case legumes
    case meat
    case fish
    case egg
    case cheese
    case cake
    case dessert
    case iceCream = "ice_cream"
    case chocolate

    var localizationKey: String { "dish_food_\(rawValue)" }

    var kcal: ClosedRange<Int> {
        switch self {
        case .pizza: return 450...850
        case .burger: return 450...800
        case .hotDog: return 250...450
        case .pasta: return 350...650
        case .rice: return 250...500
        case .bread: return 150...350
        case .sandwich: return 300...600
        case .sushi: return 300...550
        case .soup: return 150...400
        case .fries: return 250...450
        case .salad: return 100...350
        case .vegetable: return 50...200
        case .fruit: return 60...200
        case .legumes: return 200...400
        case .meat: return 300...650
        case .fish: return 200...450
        case .egg: return 150...300
        case .cheese: return 150...400
        case .cake: return 250...550
        case .dessert: return 200...500
        case .iceCream: return 200...400
        case .chocolate: return 150...350
        }
    }

    var hint: DishVeganHint? {
        switch self {
        case .pizza, .burger, .hotDog, .sushi, .meat, .fish, .egg, .cheese, .iceCream:
            return .animal
        case .fries, .salad, .vegetable, .fruit, .legumes:
            return .plant
        case .pasta, .rice, .bread, .sandwich, .soup, .cake, .dessert, .chocolate:
            return nil
        }
    }

    var labels: Set<String> {
        switch self {
        case .pizza: return ["pizza"]
        case .burger: return ["burger", "hamburger", "cheeseburger"]
        case .hotDog: return ["hot dog", "hotdog"]
        case .pasta: return ["pasta", "spaghetti", "noodle", "noodles", "lasagna", "ramen"]
        case .rice: return ["rice", "risotto", "paella", "fried rice"]
        case .bread: return ["bread", "baguette", "toast", "bagel", "croissant", "bun"]
        case .sandwich: return ["sandwich", "wrap", "burrito", "taco"]
        case .sushi: return ["sushi", "sashimi"]
        case .soup: return ["soup", "stew", "curry"]
        case .fries: return ["fries", "french fries", "potato", "potatoes"]
        case .salad: return ["salad"]
        case .vegetable:
            return [
                "vegetable", "vegetables", "broccoli", "carrot", "tomato", "cucumber",
                "lettuce", "mushroom", "zucchini", "eggplant", "corn"
            ]
        case .fruit:
            return [
                "fruit", "apple", "banana", "orange", "strawberry", "grape", "berry",
                "citrus", "pineapple", "watermelon", "melon", "mango"
            ]
        case .legumes:
            return ["legume", "legumes", "bean", "beans", "chickpea", "chickpeas", "lentil", "lentils", "hummus", "tofu"]
        case .meat:
            return [
                "meat", "steak", "beef", "pork", "bacon", "sausage", "ham", "chicken",
                "poultry", "barbecue", "kebab", "meatball"
            ]
        case .fish: return ["fish", "seafood", "shrimp", "prawn", "salmon", "tuna", "shellfish", "crab", "lobster"]
        case .egg: return ["egg", "eggs", "omelette", "omelet", "fried egg"]
        case .cheese: return ["cheese"]
        case .cake:
            return [
                "cake", "pie", "cupcake", "pastry", "muffin", "donut", "doughnut",
                "cookie", "biscuit", "waffle", "pancake"
            ]
        case .dessert: return ["dessert", "pudding"]
        case .iceCream: return ["ice cream"]
        case .chocolate: return ["chocolate"]
        }
    }
}

struct DishPhotoAnalysis: Equatable {
    let visibleFoods: [DishFood]
    let confidence: VeganConfidence
}

enum DishPhotoAnalyzer {
    static let confidenceThreshold: Float = 0.45
    private static let maxFoods = 5

    private static let foodsByLabel: [String: DishFood] = {
        var map: [String: DishFood] = [:]
        for food in DishFood.allCases {
            for label in food.labels {
                map[label] = food
            }
        }
        return map
    }()

    static func analyze(_ image: UIImage) async throws -> DishPhotoAnalysis {
        guard let cgImage = image.cgImage else {
            throw DishPhotoError.invalidImage
        }

        let labels = try await classify(cgImage, orientation: CGImagePropertyOrientation(image.imageOrientation))
        return DishPhotoAnalysis(
            visibleFoods: recognizedFoods(from: labels.map { ($0.identifier, $0.confidence) }),
            confidence: .low
        )
    }

    static func recognizedFood(_ identifier: String) -> DishFood? {
        let normalized = identifier
            .lowercased()
            .replacingOccurrences(of: "_", with: " ")
            .trimmingCharacters(in: .whitespaces)
        return foodsByLabel[normalized]
    }

    static func recognizedFoods(
        from labels: [(identifier: String, confidence: Float)],
        minConfidence: Float = confidenceThreshold
    ) -> [DishFood] {
        var foods: [DishFood] = []
        for label in labels.filter({ $0.confidence >= minConfidence }).sorted(by: { $0.confidence > $1.confidence }) {
            guard let food = recognizedFood(label.identifier), !foods.contains(food) else { continue }
            foods.append(food)
            if foods.count == maxFoods { break }
        }
        return foods
    }

    static func calories(for food: DishFood, portion: DishPortion) -> ClosedRange<Int> {
        roundToTen(Double(food.kcal.lowerBound) * portion.factor)...roundToTen(Double(food.kcal.upperBound) * portion.factor)
    }

    static func totalCalories(for foods: [DishFood], portion: DishPortion) -> ClosedRange<Int>? {
        guard !foods.isEmpty else { return nil }
        let ranges = foods.map { calories(for: $0, portion: portion) }
        return ranges.map(\.lowerBound).reduce(0, +)...ranges.map(\.upperBound).reduce(0, +)
    }

    static func veganHint(for foods: [DishFood]) -> DishVeganHint? {
        if foods.contains(where: { $0.hint == .animal }) {
            return .animal
        }
        if !foods.isEmpty, foods.allSatisfy({ $0.hint == .plant }) {
            return .plant
        }
        return nil
    }

    private static func roundToTen(_ value: Double) -> Int {
        Int((value / 10).rounded()) * 10
    }

    private static func classify(
        _ image: CGImage,
        orientation: CGImagePropertyOrientation
    ) async throws -> [VNClassificationObservation] {
        try await withCheckedThrowingContinuation { continuation in
            let request = VNClassifyImageRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(
                        returning: request.results as? [VNClassificationObservation] ?? []
                    )
                }
            }
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try VNImageRequestHandler(
                        cgImage: image,
                        orientation: orientation,
                        options: [:]
                    ).perform([request])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    enum DishPhotoError: Error {
        case invalidImage
    }
}

extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
