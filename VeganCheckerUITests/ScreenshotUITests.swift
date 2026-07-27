import XCTest

final class ScreenshotUITests: XCTestCase {
    func testCaptureKeyScreens() {
        let app = XCUIApplication()
        app.launch()

        let onboardingDismiss = app.buttons["onboarding-dismiss"]
        if onboardingDismiss.waitForExistence(timeout: 3) {
            capture(app, named: "onboarding")
            onboardingDismiss.tap()
        }

        capture(app, named: "scanner")
        captureToolbarScreen(
            app,
            buttonIdentifier: "settings-button",
            screenshotName: "settings-accessibility"
        )
        captureToolbarScreen(app, buttonIdentifier: "profile-button", screenshotName: "profile")
        captureToolbarScreen(app, buttonIdentifier: "history-button", screenshotName: "history-empty")
        captureToolbarScreen(app, buttonIdentifier: "favorites-button", screenshotName: "favorites-empty")
        captureToolbarScreen(app, buttonIdentifier: "search-button", screenshotName: "search")
    }

    private func captureToolbarScreen(
        _ app: XCUIApplication,
        buttonIdentifier: String,
        screenshotName: String
    ) {
        let button = app.buttons[buttonIdentifier]
        guard button.waitForExistence(timeout: 5) else { return }

        button.tap()
        _ = app.navigationBars.element.waitForExistence(timeout: 5)
        capture(app, named: screenshotName)
        navigateBack(app)
    }

    private func capture(_ app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func navigateBack(_ app: XCUIApplication) {
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        if backButton.waitForExistence(timeout: 2) {
            backButton.tap()
        } else {
            app.swipeRight()
        }
    }
}
