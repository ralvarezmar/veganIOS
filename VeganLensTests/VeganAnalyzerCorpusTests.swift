import XCTest
@testable import VeganLens

final class VeganAnalyzerCorpusTests: XCTestCase {
    func testSharedCorpusMatchesExpectedVerdicts() throws {
        let url = try XCTUnwrap(
            Bundle(for: type(of: self)).url(
                forResource: "vegan_verdict_corpus",
                withExtension: "json"
            )
        )
        let corpus = try JSONDecoder().decode(Corpus.self, from: Data(contentsOf: url))

        for testCase in corpus.cases {
            let analysis = analyzeVegan(
                ingredientsAnalysisTags: testCase.ingredientsAnalysisTags,
                ingredients: testCase.ingredients?.map {
                    OffIngredient(text: $0.text, vegan: $0.vegan, vegetarian: nil)
                },
                ingredientsText: testCase.ingredientsText,
                categoriesTags: testCase.categoriesTags,
                labelsTags: testCase.labelsTags
            )

            XCTAssertEqual(
                analysis.status,
                status(for: testCase.expected.status),
                "case \(testCase.id): status"
            )
            XCTAssertEqual(
                analysis.reason?.source,
                reasonSource(for: testCase.expected.reasonSource),
                "case \(testCase.id): reason source"
            )
            XCTAssertEqual(
                analysis.nonVeganIngredients + analysis.doubtfulIngredients,
                testCase.expected.culprits,
                "case \(testCase.id): culprits"
            )
        }
    }

    private func status(for value: String) -> VeganStatus {
        switch value {
        case "vegan": return .vegan
        case "notVegan": return .notVegan
        case "maybe": return .maybe
        case "unknown": return .unknown
        default: fatalError("Unknown corpus status: \(value)")
        }
    }

    private func reasonSource(for value: String) -> VeganReasonSource {
        switch value {
        case "structuredNonVeganIngredient": return .structuredNonVeganIngredient
        case "structuredDoubtfulIngredient": return .structuredDoubtfulIngredient
        case "structuredVeganIngredient": return .structuredVeganIngredient
        case "decisiveTag": return .decisiveTag
        case "heuristicText": return .heuristicText
        case "veganSeal": return .veganSeal
        case "meatAlternativeCategory": return .meatAlternativeCategory
        default: fatalError("Unknown corpus reason source: \(value)")
        }
    }
}

private struct Corpus: Decodable {
    let cases: [CorpusCase]
}

private struct CorpusCase: Decodable {
    let id: String
    let ingredientsText: String?
    let ingredientsAnalysisTags: [String]?
    let ingredients: [CorpusIngredient]?
    let categoriesTags: [String]?
    let labelsTags: [String]?
    let expected: CorpusExpected
}

private struct CorpusIngredient: Decodable {
    let text: String?
    let vegan: String?
}

private struct CorpusExpected: Decodable {
    let status: String
    let reasonSource: String
    let culprits: [String]
}
