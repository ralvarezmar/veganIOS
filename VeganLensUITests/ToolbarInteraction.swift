import XCTest

extension XCUIApplication {
    /// Taps a navigation-bar button by coordinate: `tap()` first asks the element
    /// to scroll itself visible, which a toolbar button cannot do while the
    /// navigation bar is still settling.
    @discardableResult
    func tapToolbarButton(_ identifier: String, timeout: TimeInterval = 5) -> Bool {
        let button = buttons[identifier]
        guard button.waitForExistence(timeout: timeout) else { return false }
        guard waitForSettledFrame(of: button, timeout: timeout) else { return false }
        tapVisibleElement(button)
        return true
    }

    @discardableResult
    func tapNavigationBackButton(timeout: TimeInterval = 5) -> Bool {
        let button = navigationBars.buttons.element(boundBy: 0)
        guard button.waitForExistence(timeout: timeout) else { return false }
        guard waitForSettledFrame(of: button, timeout: timeout) else { return false }
        tapVisibleElement(button)
        return true
    }

    private func tapVisibleElement(_ element: XCUIElement) {
        element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    private func waitForSettledFrame(of element: XCUIElement, timeout: TimeInterval) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        var previous = element.frame
        var stableSamples = 0
        while Date() < deadline {
            Thread.sleep(forTimeInterval: 0.2)
            let current = element.frame
            if !current.isEmpty && current == previous {
                stableSamples += 1
                if stableSamples >= 3 {
                    return true
                }
            } else {
                stableSamples = 0
            }
            previous = current
        }
        return !element.frame.isEmpty
    }
}
