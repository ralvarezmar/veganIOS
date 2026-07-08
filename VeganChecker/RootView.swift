import SwiftUI

struct RootView: View {
    @State private var path = NavigationPath()

    @State private var scannerRunning = true
    @AppStorage("onboarding_seen") private var onboardingSeen = false
    @State private var showingOnboarding = false

    var body: some View {
        NavigationStack(path: $path) {
            ScannerView(
                isScannerRunning: $scannerRunning,
                onDetectedBarcode: { barcode in
                    scannerRunning = false
                    path.append(Route.result(barcode))
                }
            )
            .navigationTitle(L("app_name"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L("history_action")) {
                        path.append(Route.history)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        path.append(Route.favorites)
                    } label: {
                        Image(systemName: "star")
                    }
                    .accessibilityLabel(L("favorites_action"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        path.append(Route.search)
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .accessibilityLabel(L("search_action"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        path.append(Route.profile)
                    } label: {
                        Image(systemName: "person.circle")
                    }
                    .accessibilityLabel(L("profile_action"))
                }
            }
            .sheet(isPresented: $showingOnboarding, onDismiss: {
                onboardingSeen = true
                scannerRunning = path.isEmpty
            }) {
                OnboardingView {
                    showingOnboarding = false
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .history:
                    HistoryView { barcode in
                        path.append(Route.result(barcode))
                    }
                case .favorites:
                    FavoritesScreen { barcode in
                        path.append(Route.result(barcode))
                    }
                case .search:
                    SearchScreen { barcode in
                        path.append(Route.result(barcode))
                    }
                case .profile:
                    ProfileScreen()
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
        .onAppear {
            if !onboardingSeen {
                showingOnboarding = true
                scannerRunning = false
            }
        }
        .onChange(of: path.count) { _, newValue in
            scannerRunning = newValue == 0
        }
    }
}

private enum Route: Hashable {
    case history
    case favorites
    case search
    case profile
    case result(String)
}
