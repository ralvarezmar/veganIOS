import Combine
import UIKit

private let quickScanActionType = "com.ralvarezmar.vcheck.quick-scan"

final class QuickActionRouter: ObservableObject {
    @Published private(set) var requestID = 0

    func handle(_ shortcutItem: UIApplicationShortcutItem?) {
        guard shortcutItem?.type == quickScanActionType else { return }
        requestID += 1
    }
}

final class VeganLensAppDelegate: NSObject, UIApplicationDelegate {
    let quickActionRouter = QuickActionRouter()

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            quickActionRouter.handle(shortcutItem)
        }

        let configuration = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = QuickActionSceneDelegate.self
        return configuration
    }

    func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        quickActionRouter.handle(shortcutItem)
        completionHandler(shortcutItem.type == quickScanActionType)
    }
}

final class QuickActionSceneDelegate: NSObject, UIWindowSceneDelegate {
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let appDelegate = UIApplication.shared.delegate as? VeganLensAppDelegate
        appDelegate?.quickActionRouter.handle(shortcutItem)
        completionHandler(shortcutItem.type == quickScanActionType)
    }
}
