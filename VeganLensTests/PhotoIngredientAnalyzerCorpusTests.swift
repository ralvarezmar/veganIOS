import XCTest
@testable import VeganLens

final class PhotoIngredientAnalyzerCorpusTests: XCTestCase {
    func testSharedPhotoCorpusMatchesExpectedAnalyses() throws {
        let url = try XCTUnwrap(
            Bundle(for: type(of: self)).url(
                forResource: "vegan_photo_corpus",
                withExtension: "json"
            )
        )
        let corpus = try JSONDecoder().decode(PhotoCorpus.self, from: Data(contentsOf: url))

        for testCase in corpus.cases {
            let analysis = analyzePhotoIngredients(testCase.text, preferredLanguage: "es")
            XCTAssertEqual(
                analysis.status,
                status(for: testCase.expected.status),
                "case \(testCase.id): status"
            )
            XCTAssertEqual(
                analysis.reasonSource,
                reasonSource(for: testCase.expected.reasonSource),
                "case \(testCase.id): reason source"
            )
            XCTAssertEqual(
                analysis.culprits.map(\.label),
                testCase.expected.culprits,
                "case \(testCase.id): culprits"
            )
            XCTAssertEqual(
                analysis.unrecognizedSegments,
                testCase.expected.unrecognized,
                "case \(testCase.id): unrecognized"
            )
            XCTAssertEqual(
                analysis.traceWarning,
                testCase.expected.traceWarning,
                "case \(testCase.id): trace warning"
            )
        }
    }

    private func status(for value: String) -> PhotoVeganStatus {
        switch value {
        case "notVegan": return .notVegan
        case "vegan": return .vegan
        case "review": return .review
        default: fatalError("Unknown photo corpus status: \(value)")
        }
    }

    private func reasonSource(for value: String) -> PhotoReasonSource {
        switch value {
        case "photoAnimalIngredient": return .animalIngredient
        case "photoAnimalAdditive": return .animalAdditive
        case "photoAllPlantRecognized": return .allPlantRecognized
        case "photoUnrecognizedIngredient": return .unrecognizedIngredient
        case "photoLanguageNotRecognized": return .languageNotRecognized
        default: fatalError("Unknown photo corpus reason source: \(value)")
        }
    }
}

private struct PhotoCorpus: Decodable {
    let cases: [PhotoCorpusCase]
}

private struct PhotoCorpusCase: Decodable {
    let id: String
    let text: String
    let expected: PhotoCorpusExpected
}

private struct PhotoCorpusExpected: Decodable {
    let status: String
    let reasonSource: String
    let culprits: [String]
    let unrecognized: [String]
    let traceWarning: Bool
}
