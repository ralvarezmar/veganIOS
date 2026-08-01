import XCTest

final class VeganCheckerUITests: XCTestCase {
    func testAppLaunchesAndShowsScannerScreen() {
        let app = launchApp()

        XCTAssertTrue(app.waitForExistence(timeout: 5))
        XCTAssertTrue(
            app.descendants(matching: .any)["main-scanner-screen"].waitForExistence(timeout: 5)
        )
    }

    func testSettingsShowsPrivacyPolicyRow() {
        let app = launchApp()
        let settingsButton = app.buttons["settings-button"]

        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()

        let privacyPolicyRow = app.descendants(matching: .any)["privacy-policy-row"]
        XCTAssertTrue(privacyPolicyRow.waitForExistence(timeout: 5))
    }

    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()

        let onboardingDismiss = app.buttons["onboarding-dismiss"]
        if onboardingDismiss.waitForExistence(timeout: 2) {
            onboardingDismiss.tap()
        }

        return app
    }
}
