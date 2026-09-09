import SwiftUI
import SwiftData

@main
struct VeganLensApp: App {
    @UIApplicationDelegateAdaptor(VeganLensAppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ScanRecord.self, CachedProduct.self, FavoriteProduct.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("No se pudo crear el contenedor de SwiftData: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView(quickActionRouter: appDelegate.quickActionRouter)
        }
        .modelContainer(sharedModelContainer)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                B12ReminderScheduler.refreshIfEnabled()
            }
        }
    }
}
