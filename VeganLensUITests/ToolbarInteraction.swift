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
        return tapVisibleElement(button, identifier: identifier, timeout: timeout)
    }

    @discardableResult
    func tapNavigationBackButton(timeout: TimeInterval = 5) -> Bool {
        let button = navigationBars.buttons.element(boundBy: 0)
        guard button.waitForExistence(timeout: timeout) else { return false }
        guard waitForSettledFrame(of: button, timeout: timeout) else { return false }
        return tapVisibleElement(button, identifier: button.identifier, timeout: timeout)
    }

    private func tapVisibleElement(
        _ element: XCUIElement,
        identifier: String,
        timeout: TimeInterval
    ) -> Bool {
        let navigationBar = navigationBars.firstMatch
        guard waitForHittable(of: element, timeout: timeout) else {
            printTapDiagnostics(
                phase: "before tap",
                element: element,
                identifier: identifier,
                navigationBar: navigationBar
            )
            return false
        }
        printTapDiagnostics(
            phase: "before tap",
            element: element,
            identifier: identifier,
            navigationBar: navigationBar
        )
        element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        printTapDiagnostics(
            phase: "after tap",
            element: element,
            identifier: identifier,
            navigationBar: navigationBar
        )
        if navigationBar.exists {
            let navigationBarButtons = navigationBar.buttons
            for index in 0..<navigationBarButtons.count {
                let button = navigationBarButtons.element(boundBy: index)
                let buttonExists = button.exists
                print(
                    "UI-DIAG after tap navigationBarButton[\(index)] " +
                        "identifier=\(buttonExists ? button.identifier : \"\") " +
                        "frame=\(buttonExists ? button.frame : CGRect.zero)"
                )
            }
        }
        return true
    }

    private func printTapDiagnostics(
        phase: String,
        element: XCUIElement,
        identifier: String,
        navigationBar: XCUIElement
    ) {
        let elementExists = element.exists
        let elementFrame = elementExists ? element.frame : CGRect.zero
        let elementIsHittable = elementExists && element.isHittable
        let navigationBarExists = navigationBar.exists
        let navigationBarFrame = navigationBarExists ? navigationBar.frame : CGRect.zero
        print(
            "UI-DIAG \(phase) identifier=\(identifier) frame=\(elementFrame) " +
                "isHittable=\(elementIsHittable) exists=\(elementExists) " +
                "navigationBarFrame=\(navigationBarFrame)"
        )
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

    private func waitForHittable(of element: XCUIElement, timeout: TimeInterval) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if element.exists && element.isHittable {
                return true
            }
            Thread.sleep(forTimeInterval: 0.2)
        }
        return element.exists && element.isHittable
    }
}
