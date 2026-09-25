import UIKit
import Vision

struct DishPhotoAnalysis: Equatable {
    let visibleFoods: [String]
    let calorieRange: ClosedRange<Int>?
    let confidence: VeganConfidence
}

enum DishPhotoAnalyzer {
    private enum FoodGroup: Hashable {
        case main
        case plant
        case dessert
    }

    static func analyze(_ image: UIImage) async throws -> DishPhotoAnalysis {
        guard let cgImage = image.cgImage else {
            throw DishPhotoError.invalidImage
        }

        let labels = try await classify(cgImage, orientation: .up)
        let recognizedFoods = labels
            .filter { $0.confidence >= 0.45 }
            .compactMap { observation -> (String, FoodGroup)? in
                guard let group = recognizedFoodGroup(observation.identifier) else {
                    return nil
                }
                return (observation.identifier.replacingOccurrences(of: "_", with: " "), group)
            }
            .reduce(into: [(String, FoodGroup)]()) { result, food in
                guard !result.contains(where: { $0.0 == food.0 }) else { return }
                result.append(food)
            }
            .prefix(5)

        let foods = Array(recognizedFoods.map(\.0))
        let groups = Set(recognizedFoods.map(\.1))
        let range: ClosedRange<Int>?
        if groups.contains(.main) {
            range = 350...800
        } else if groups.contains(.dessert) {
            range = 250...650
        } else if groups.contains(.plant) {
            range = 100...450
        } else {
            range = nil
        }

        return DishPhotoAnalysis(
            visibleFoods: foods,
            calorieRange: range,
            confidence: .low
        )
    }

    private static func recognizedFoodGroup(_ identifier: String) -> FoodGroup? {
        switch identifier.lowercased() {
        case "pizza", "burger", "hamburger", "pasta":
            return .main
        case "salad", "fruit", "vegetable", "vegetables":
            return .plant
        case "cake", "dessert", "ice cream":
            return .dessert
        default:
            return nil
        }
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
