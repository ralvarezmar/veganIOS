import SwiftUI

struct RootView: View {
    @ObservedObject var quickActionRouter: QuickActionRouter
    @State private var path = NavigationPath()

    @State private var scannerRunning = true
    @State private var contributionProduct: Product?
    @AppStorage("onboarding_seen") private var onboardingSeen = false
    @AppStorage(AccessibilityPreferences.textSizeKey) private var textSize = AccessibilityTextSize.normal.rawValue
    @State private var showingOnboarding = false

    private func resetToScanner() {
        path = NavigationPath()
        scannerRunning = true
        showingOnboarding = false
    }

    var body: some View {
        Group {
            if let selectedTextSize = AccessibilityTextSize(rawValue: textSize),
               selectedTextSize != .normal {
                navigationContent.environment(\.dynamicTypeSize, selectedTextSize.dynamicTypeSize)
            } else {
                navigationContent
            }
        }
        .onAppear {
            if quickActionRouter.requestID > 0 {
                resetToScanner()
            } else if !onboardingSeen {
                showingOnboarding = true
                scannerRunning = false
            }
        }
        .onChange(of: path.count) { _, newValue in
            scannerRunning = newValue == 0
        }
        .onChange(of: quickActionRouter.requestID) {
            resetToScanner()
        }
    }

    private var navigationContent: some View {
        NavigationStack(path: $path) {
            ScannerView(
                isScannerRunning: $scannerRunning,
                onDetectedBarcode: { barcode in
                    scannerRunning = false
                    path.append(Route.result(barcode))
                }
            )
            .accessibilityIdentifier("main-scanner-screen")
            .navigationTitle(L("app_name"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarItems }
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
                    HistoryView(
                        onSelectBarcode: { barcode in
                            path.append(Route.result(barcode))
                        },
                        onScanProduct: {
                            if !path.isEmpty {
                                path.removeLast()
                            }
                        }
                    )
                case .favorites:
                    FavoritesScreen(
                        onSelectBarcode: { barcode in
                            path.append(Route.result(barcode))
                        },
                        onScanProduct: {
                            if !path.isEmpty {
                                path.removeLast()
                            }
                        }
                    )
                case .search:
                    SearchScreen { barcode in
                        path.append(Route.result(barcode))
                    }
                case .profile:
                    ProfileScreen()
                case .settings:
                    SettingsView()
                case .result(let barcode):
                    ResultView(
                        barcode: barcode,
                        onContribute: { contributionBarcode, product, source in
                            contributionProduct = product
                            path.append(Route.contribution(contributionBarcode, source?.rawValue))
                        },
                        onSelectBarcode: { alternativeBarcode in
                            path.append(Route.result(alternativeBarcode))
                        },
                        onBack: {
                            if !path.isEmpty {
                                path.removeLast()
                            }
                        }
                    )
                case .contribution(let barcode, let sourceName):
                    ContributionView(
                        barcode: barcode,
                        initialSource: sourceName.flatMap(ProductSource.init(rawValue:)),
                        product: contributionProduct,
                        onBack: {
                            if !path.isEmpty {
                                path.removeLast()
                            }
                        }
                    )
                }
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(L("history_action")) {
                path.append(Route.history)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                path.append(Route.settings)
            } label: {
                Image(systemName: "gearshape")
            }
            .accessibilityLabel(L("settings_action"))
            .accessibilityIdentifier("settings-button")
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
}

private enum Route: Hashable {
    case history
    case favorites
    case search
    case profile
    case settings
    case result(String)
    case contribution(String, String?)
}
