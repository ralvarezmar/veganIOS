import XCTest
import UIKit

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
        guard app.tapToolbarButton(buttonIdentifier) else { return }
        _ = app.navigationBars.element.waitForExistence(timeout: 5)
        capture(app, named: screenshotName)
        navigateBack(app)
    }

    private func capture(_ app: XCUIApplication, named name: String) {
        XCTContext.runActivity(named: name) { activity in
            let path = FileManager.default.temporaryDirectory
                .appendingPathComponent("\(name).png")
            try? app.screenshot().image.pngData()?.write(to: path)
            defer { try? FileManager.default.removeItem(at: path) }
            let attachment = XCTAttachment(contentsOfFile: path)
            attachment.name = name
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }

    private func navigateBack(_ app: XCUIApplication) {
        if !app.tapNavigationBackButton(timeout: 2) {
            app.swipeRight()
        }
    }
}
