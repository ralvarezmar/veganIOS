import XCTest
import UIKit

final class ScreenshotUITests: XCTestCase {
    func testCaptureKeyScreens() {
        let app = XCUIApplication()
        installSystemPermissionMonitor()
        app.launch()

        let onboardingDismiss = app.buttons["onboarding-dismiss"]
        if onboardingDismiss.waitForExistence(timeout: 15) {
            capture(app, named: "onboarding")
            onboardingDismiss.tap()
        }

        capture(app, named: "scanner")
        captureTab(app, index: 3, screenshotName: "settings-accessibility")
        captureToolbarScreen(app, buttonIdentifier: "profile-button", screenshotName: "profile")
        captureTab(app, index: 1, screenshotName: "history-empty")
        if app.tapTab(1) {
            let favoritesSegment = app.segmentedControls.buttons.element(boundBy: 1)
            if favoritesSegment.waitForExistence(timeout: 5) {
                favoritesSegment.tap()
                capture(app, named: "favorites-empty")
                app.segmentedControls.buttons.element(boundBy: 0).tap()
            }
            app.tapTab(0)
        }
        captureToolbarScreen(app, buttonIdentifier: "search-button", screenshotName: "search")
    }

    private func captureTab(_ app: XCUIApplication, index: Int, screenshotName: String) {
        guard app.tapTab(index) else { return }
        _ = app.navigationBars.element.waitForExistence(timeout: 5)
        capture(app, named: screenshotName)
        app.tapTab(0)
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
