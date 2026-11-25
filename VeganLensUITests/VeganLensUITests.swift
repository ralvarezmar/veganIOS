import XCTest

final class VeganLensUITests: XCTestCase {
    func testAppLaunchesAndShowsScannerScreen() {
        let app = launchApp()

        XCTAssertTrue(app.waitForExistence(timeout: 5))
        XCTAssertTrue(
            app.descendants(matching: .any)["main-scanner-screen"].waitForExistence(timeout: 5)
        )
    }

    func testSettingsShowsPrivacyPolicyRow() {
        let app = launchApp()

        XCTAssertTrue(app.tapToolbarButton("settings-button"))

        let privacyPolicyRow = app.descendants(matching: .any)["privacy-policy-row"]
        XCTAssertTrue(privacyPolicyRow.waitForExistence(timeout: 5), app.debugDescription)
    }

    func testMedicineSearchFieldAcceptsTyping() {
        let app = launchApp()

        XCTAssertTrue(app.tapToolbarButton("search-button"))

        let picker = app.segmentedControls["search_mode_picker"]
        XCTAssertTrue(picker.waitForExistence(timeout: 5), app.debugDescription)
        picker.buttons.element(boundBy: 1).tap()

        let field = app.textFields["search-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 5), app.debugDescription)
        field.tap()
        field.typeText("ibuprofeno")

        XCTAssertEqual(field.value as? String, "ibuprofeno", app.debugDescription)
    }

    func testFoodSearchFieldAcceptsTyping() {
        let app = launchApp()

        XCTAssertTrue(app.tapToolbarButton("search-button"))

        let field = app.textFields["search-field"]
        XCTAssertTrue(field.waitForExistence(timeout: 5), app.debugDescription)
        field.tap()
        field.typeText("tofu")

        XCTAssertEqual(field.value as? String, "tofu", app.debugDescription)
    }

    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        installSystemPermissionMonitor()
        app.launch()

        let onboardingDismiss = app.buttons["onboarding-dismiss"]
        if onboardingDismiss.waitForExistence(timeout: 15) {
            onboardingDismiss.tap()
        }

        return app
    }
}
