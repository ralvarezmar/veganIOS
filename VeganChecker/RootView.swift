import SwiftUI

struct RootView: View {
    @State private var path = NavigationPath()

    @State private var scannerRunning = true

    var body: some View {
        NavigationStack(path: $path) {
            ScannerView(
                isScannerRunning: $scannerRunning,
                onDetectedBarcode: { barcode in
                    scannerRunning = false
                    path.append(Route.result(barcode))
                }
            )
            .navigationTitle("VeganChecker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Historial") {
                        path.append(Route.history)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .history:
                    HistoryView { barcode in
                        path.append(Route.result(barcode))
                    }
                case .result(let barcode):
                    ResultView(
                        barcode: barcode,
                        onBack: {
                            if !path.isEmpty {
                                path.removeLast()
                            }
                        }
                    )
                }
            }
        }
        .onChange(of: path.count) { _, newValue in
            scannerRunning = newValue == 0
        }
    }
}

private enum Route: Hashable {
    case history
    case result(String)
}
