import ImageIO
import UIKit
import Vision

func cleanRecognizedIngredientText(_ rawText: String) -> String {
    let withoutControlCharacters = rawText.unicodeScalars.filter {
        !CharacterSet.controlCharacters.contains($0) && $0 != "\u{0}"
    }
    return String(withoutControlCharacters.map { Character(String($0)) })
        .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

enum IngredientOCR {
    static func recognizeText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw OCRError.invalidImage
        }

        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let request = VNRecognizeTextRequest { request, error in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let observations = request.results as? [VNRecognizedTextObservation] ?? []
                    let text = observations.compactMap {
                        $0.topCandidates(1).first?.string
                    }.joined(separator: "\n")
                    continuation.resume(returning: cleanRecognizedIngredientText(text))
                }
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = true
                request.recognitionLanguages = ["es-ES", "en-US"]

                do {
                    let handler = VNImageRequestHandler(
                        cgImage: cgImage,
                        orientation: image.imageOrientation.visionOrientation,
                        options: [:]
                    )
                    try handler.perform([request])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    enum OCRError: Error {
        case invalidImage
    }
}

private extension UIImage.Orientation {
    var visionOrientation: CGImagePropertyOrientation {
        switch self {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }
}
