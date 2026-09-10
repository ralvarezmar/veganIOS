import XCTest
@testable import VeganLens

final class ReasonOriginHintTests: XCTestCase {
    func testRequiresOriginHintForNamedDairyFlavourWithEvidence() {
        XCTAssertTrue(reasonNeedsOriginHint(.flavourDairyName, evidenceCount: 1))
    }

    func testRequiresOriginHintForStructuredDoubtfulIngredientWithEvidence() {
        XCTAssertTrue(reasonNeedsOriginHint(.structuredDoubtfulIngredient, evidenceCount: 2))
    }

    func testRequiresOriginHintForUncertainAdditiveWithEvidence() {
        XCTAssertTrue(reasonNeedsOriginHint(.additiveUncertain, evidenceCount: 1))
    }

    func testDoesNotRequireOriginHintWithoutEvidence() {
        XCTAssertFalse(reasonNeedsOriginHint(.flavourDairyName, evidenceCount: 0))
        XCTAssertFalse(reasonNeedsOriginHint(.structuredDoubtfulIngredient, evidenceCount: 0))
        XCTAssertFalse(reasonNeedsOriginHint(.additiveUncertain, evidenceCount: 0))
    }

    func testDoesNotRequireOriginHintForOtherSources() {
        XCTAssertFalse(reasonNeedsOriginHint(.structuredNonVeganIngredient, evidenceCount: 1))
        XCTAssertFalse(reasonNeedsOriginHint(.veganSeal, evidenceCount: 1))
    }
}
