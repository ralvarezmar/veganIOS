import SwiftUI

private let lastPortadaCharacterKey = "last_portada_character"

private enum PortadaSession {
    static var hasShown = false
}

struct RootView: View {
    @ObservedObject var quickActionRouter: QuickActionRouter
    @State private var path = NavigationPath()

    @State private var scannerRunning = false
    @State private var contributionProduct: Product?
    @AppStorage("onboarding_seen") private var onboardingSeen = false
    @AppStorage(AccessibilityPreferences.textSizeKey) private var textSize = AccessibilityTextSize.normal.rawValue
    @AppStorage(AccessibilityPreferences.highLegibilityFontKey) private var highLegibilityFont = false
    @State private var showingOnboarding = false
    @State private var showingPortada = false
    @State private var portadaCharacter: String?

    private func resetToScanner() {
        path = NavigationPath()
        scannerRunning = !showingPortada
        showingOnboarding = false
    }

    var body: some View {
        Group {
            if let selectedTextSize = AccessibilityTextSize(rawValue: textSize),
               selectedTextSize != .normal {
                appContent
                    .environment(\.dynamicTypeSize, selectedTextSize.dynamicTypeSize)
            } else {
                appContent
            }
        }
        .environment(\.highLegibilityFont, highLegibilityFont)
        .onAppear {
            let didShowPortada = showPortadaIfNeeded()
            if quickActionRouter.requestID > 0 {
                resetToScanner()
                scannerRunning = !didShowPortada
            } else if !didShowPortada && !onboardingSeen {
                showingOnboarding = true
                scannerRunning = false
            } else if !didShowPortada {
                scannerRunning = true
            }
        }
        .onChange(of: path.count) { _, newValue in
            scannerRunning = !showingPortada && newValue == 0
        }
        .onChange(of: quickActionRouter.requestID) {
            resetToScanner()
        }
        .onOpenURL { url in
            guard url.scheme == "vcheck",
                  url.host == "scan" || url.path == "/scan" else {
                return
            }
            resetToScanner()
        }
    }

    private var appContent: some View {
        ZStack {
            navigationContent

            if showingPortada, let portadaCharacter {
                PortadaSplashView(
                    character: portadaCharacter,
                    onDismiss: dismissPortada
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showingPortada)
    }

    private func showPortadaIfNeeded() -> Bool {
        guard !PortadaSession.hasShown else {
            return false
        }

        PortadaSession.hasShown = true
        let previous = UserDefaults.standard.string(forKey: lastPortadaCharacterKey)
        let selected = selectPortadaCharacter(previous: previous)
        UserDefaults.standard.set(selected, forKey: lastPortadaCharacterKey)
        portadaCharacter = selected
        showingPortada = true
        scannerRunning = false
        return true
    }

    private func dismissPortada() {
        showingPortada = false
        scannerRunning = path.isEmpty
        if quickActionRouter.requestID == 0 && !onboardingSeen {
            showingOnboarding = true
            scannerRunning = false
        }
    }

    private var navigationContent: some View {
        NavigationStack(path: $path) {
            ScannerView(
                isScannerRunning: $scannerRunning,
                onDetectedBarcode: { barcode in
                    scannerRunning = false
                    path.append(Route.result(barcode))
                },
                onPhotoAnalysis: {
                    scannerRunning = false
                    path.append(Route.photoOCR)
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
                case .photoOCR:
                    PhotoIngredientOCRView(
                        onTextRecognized: { text in
                            if !path.isEmpty {
                                path.removeLast()
                            }
                            path.append(Route.photoResult(text))
                        },
                        onBack: {
                            if !path.isEmpty {
                                path.removeLast()
                            }
                        }
                    )
                case .photoResult(let text):
                    PhotoIngredientResultView(
                        initialText: text,
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
            .accessibilityIdentifier("history-button")
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
            .accessibilityIdentifier("favorites-button")
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                path.append(Route.search)
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .accessibilityLabel(L("search_action"))
            .accessibilityIdentifier("search-button")
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                path.append(Route.profile)
            } label: {
                Image(systemName: "person.circle")
            }
            .accessibilityLabel(L("profile_action"))
            .accessibilityIdentifier("profile-button")
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
    case photoOCR
    case photoResult(String)
}
