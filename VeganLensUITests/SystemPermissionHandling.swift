import XCTest

extension XCTestCase {
    func installSystemPermissionMonitor() {
        _ = addUIInterruptionMonitor(withDescription: "system-permission") { alert in
            for label in ["OK", "Allow", "Permitir", "Aceptar"] {
                let button = alert.buttons[label]
                if button.exists {
                    button.tap()
                    return true
                }
            }

            let buttons = alert.buttons
            if buttons.count > 0 {
                buttons.element(boundBy: buttons.count - 1).tap()
                return true
            }

            return false
        }
    }
}
