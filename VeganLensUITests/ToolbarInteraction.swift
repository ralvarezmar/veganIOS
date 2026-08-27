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
        button.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        return true
    }

    private func waitForSettledFrame(of element: XCUIElement, timeout: TimeInterval) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        var previous = element.frame
        while Date() < deadline {
            Thread.sleep(forTimeInterval: 0.2)
            let current = element.frame
            if !current.isEmpty && current == previous {
                return true
            }
            previous = current
        }
        return !element.frame.isEmpty
    }
}
