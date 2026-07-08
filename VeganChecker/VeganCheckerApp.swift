import SwiftUI
import SwiftData

@main
struct VeganCheckerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ScanRecord.self, CachedProduct.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("No se pudo crear el contenedor de SwiftData: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
