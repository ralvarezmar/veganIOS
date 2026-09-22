import UIKit
import Vision

struct DishPhotoAnalysis: Equatable {
    let visibleFoods: [String]
    let calorieRange: ClosedRange<Int>
    let confidence: VeganConfidence
}

enum DishPhotoAnalyzer {
    static func analyze(_ image: UIImage) async throws -> DishPhotoAnalysis {
        guard let cgImage = image.cgImage else {
            throw DishPhotoError.invalidImage
        }

        let labels = try await classify(cgImage, orientation: .up)
        let foods = labels
            .filter { $0.confidence >= 0.25 }
            .map(\.identifier)
            .filter { $0.count > 2 }
            .prefix(5)
            .map { $0.replacingOccurrences(of: "_", with: " ") }

        let identifiers = Set(labels.map { $0.identifier.lowercased() })
        let range: ClosedRange<Int>
        if identifiers.contains(where: { $0.contains("pizza") || $0.contains("burger") || $0.contains("pasta") }) {
            range = 500...1_200
        } else if identifiers.contains(where: { $0.contains("salad") || $0.contains("fruit") || $0.contains("vegetable") }) {
            range = 150...700
        } else if identifiers.contains(where: { $0.contains("dessert") || $0.contains("cake") || $0.contains("ice cream") }) {
            range = 300...900
        } else {
            range = 250...1_000
        }

        return DishPhotoAnalysis(
            visibleFoods: Array(foods),
            calorieRange: range,
            confidence: .low
        )
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
