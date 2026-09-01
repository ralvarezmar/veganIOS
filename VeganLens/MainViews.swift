import Foundation
import SwiftUI
import Charts
import SwiftData
import AVFoundation
import UIKit
import Translation

private func cacheAgeText(_ date: Date) -> String {
    let age = cacheAge(from: date)
    switch age.unit {
    case .seconds:
        return LF("cache_age_seconds", age.value)
    case .minute:
        return L("cache_age_minute")
    case .minutes:
        return LF("cache_age_minutes", age.value)
    case .hour:
        return L("cache_age_hour")
    case .hours:
        return LF("cache_age_hours", age.value)
    case .day:
        return L("cache_age_day")
    case .days:
        return LF("cache_age_days", age.value)
    }
}

struct ScannerView: View {
    @Binding var isScannerRunning: Bool
    let onDetectedBarcode: (String) -> Void
    let onPhotoAnalysis: () -> Void

    @State private var authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    @State private var isRequestingAccess = false
    @State private var detectedBarcode: String?
    @State private var showingDetectionConfirmation = false
    @State private var pendingNavigationTask: Task<Void, Never>?
    @State private var showingManualBarcodeEntry = false
    @State private var didSubmitManualBarcode = false

    var body: some View {
        ZStack {
            if authorizationStatus == .authorized {
                BarcodeScannerView(isRunning: $isScannerRunning) { barcode in
                    handleDetection(barcode)
                }
                .ignoresSafeArea()

                ScannerOverlayView(
                    showingDetectionConfirmation: showingDetectionConfirmation,
                    onManualEntry: presentManualBarcodeEntry,
                    onPhotoAnalysis: onPhotoAnalysis
                )
                    .ignoresSafeArea()
            } else {
                CameraPermissionView(
                    status: authorizationStatus,
                    isRequestingAccess: isRequestingAccess,
                    onRequestAccess: requestCameraAccess,
                    onOpenSettings: openSettings,
                    onManualEntry: presentManualBarcodeEntry,
                    onPhotoAnalysis: onPhotoAnalysis
                )
                .padding()
            }
        }
        .onAppear {
            updateAuthorizationState()
        }
        .onChange(of: isScannerRunning) { _, newValue in
            if newValue {
                detectedBarcode = nil
                showingDetectionConfirmation = false
                pendingNavigationTask?.cancel()
            }
        }
        .onChange(of: authorizationStatus) { _, newValue in
            isScannerRunning = newValue == .authorized
        }
        .onDisappear {
            pendingNavigationTask?.cancel()
        }
        .sheet(isPresented: $showingManualBarcodeEntry) {
            ManualBarcodeEntrySheet { barcode in
                handleManualBarcodeEntry(barcode)
            }
            .onDisappear {
                if !didSubmitManualBarcode && authorizationStatus == .authorized {
                    isScannerRunning = true
                }
            }
        }
    }

    private func handleDetection(_ barcode: String) {
        guard detectedBarcode == nil else { return }
        detectedBarcode = barcode
        isScannerRunning = false
        withAnimation(.easeInOut(duration: 0.2)) {
            showingDetectionConfirmation = true
        }

        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        pendingNavigationTask?.cancel()
        pendingNavigationTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(320))
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                showingDetectionConfirmation = false
            }
            onDetectedBarcode(barcode)
        }
    }

    private func updateAuthorizationState() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        authorizationStatus = status

        if status == .notDetermined {
            requestCameraAccess()
        }

        isScannerRunning = status == .authorized
    }

    private func requestCameraAccess() {
        guard !isRequestingAccess else { return }
        isRequestingAccess = true

        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                isRequestingAccess = false
                authorizationStatus = granted ? .authorized : .denied
                isScannerRunning = granted
            }
        }
    }

    private func handleManualBarcodeEntry(_ barcode: String) {
        didSubmitManualBarcode = true
        isScannerRunning = false
        showingManualBarcodeEntry = false
        onDetectedBarcode(barcode)
    }

    private func presentManualBarcodeEntry() {
        didSubmitManualBarcode = false
        detectedBarcode = nil
        showingDetectionConfirmation = false
        pendingNavigationTask?.cancel()
        isScannerRunning = false
        showingManualBarcodeEntry = true
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

private struct ScannerOverlayView: View {
    let showingDetectionConfirmation: Bool
    let onManualEntry: () -> Void
    let onPhotoAnalysis: () -> Void

    var body: some View {
        GeometryReader { proxy in
            let frameWidth = min(proxy.size.width * 0.82, 320)
            let frameHeight = frameWidth * 0.62
            let frameRect = CGRect(
                x: (proxy.size.width - frameWidth) / 2,
                y: (proxy.size.height - frameHeight) / 2,
                width: frameWidth,
                height: frameHeight
            )

            ZStack {
                Path { path in
                    path.addRect(CGRect(origin: .zero, size: proxy.size))
                    path.addRoundedRect(in: frameRect, cornerSize: CGSize(width: 28, height: 28))
                }
                .fill(Color.black.opacity(0.54), style: FillStyle(eoFill: true))

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.9), lineWidth: 3)
                    .frame(width: frameWidth, height: frameHeight)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)

                VStack {
                    Spacer()

                    if showingDetectionConfirmation {
                        DetectionConfirmationView()
                            .padding(.bottom, 24)
                    }

                    HelperCardView(
                        onManualEntry: onManualEntry,
                        onPhotoAnalysis: onPhotoAnalysis
                    )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

private struct HelperCardView: View {
    let onManualEntry: () -> Void
    let onPhotoAnalysis: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(L("scan_instruction"))
                .appFont(.headline, weight: .semibold)
            Text(L("scan_formats_hint"))
                .appFont(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                onManualEntry()
            } label: {
                Label(L("manual_barcode_entry"), systemImage: "keyboard")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(Color("AccentColor"))
            .padding(.top, 8)

            Button {
                onPhotoAnalysis()
            } label: {
                Label(L("photo_ingredients_action"), systemImage: "text.viewfinder")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.secondary.opacity(0.14), lineWidth: 1)
        )
    }
}

private struct DetectionConfirmationView: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .appFont(.title3, weight: .semibold)
            VStack(alignment: .leading, spacing: 2) {
                Text(L("scanner_confirmation"))
                    .appFont(.headline, weight: .semibold)
                Text(L("scanner_confirmation_subtitle"))
                    .appFont(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}

private struct CameraPermissionView: View {
    let status: AVAuthorizationStatus
    let isRequestingAccess: Bool
    let onRequestAccess: () -> Void
    let onOpenSettings: () -> Void
    let onManualEntry: () -> Void
    let onPhotoAnalysis: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 18) {
                Image(systemName: "camera.viewfinder")
                    .appIconFont(size: 48, weight: .semibold)
                    .foregroundStyle(Color.green)

                Text(L("permission_title"))
                    .appFont(.title2, weight: .bold)
                    .multilineTextAlignment(.center)

                Text(statusMessage)
                    .appFont(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                if status == .notDetermined {
                    Button {
                        onRequestAccess()
                    } label: {
                        Label(isRequestingAccess ? L("permission_requesting") : L("permission_grant"), systemImage: "camera.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("AccentColor"))
                    .disabled(isRequestingAccess)

                    Button {
                        onManualEntry()
                    } label: {
                        Label(L("manual_barcode_entry"), systemImage: "keyboard")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        onPhotoAnalysis()
                    } label: {
                        Label(L("photo_ingredients_action"), systemImage: "text.viewfinder")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                } else {
                    Button {
                        onOpenSettings()
                    } label: {
                        Label(L("permission_settings"), systemImage: "gearshape")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("AccentColor"))

                    Button {
                        onManualEntry()
                    } label: {
                        Label(L("manual_barcode_entry"), systemImage: "keyboard")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        onPhotoAnalysis()
                    } label: {
                        Label(L("photo_ingredients_action"), systemImage: "text.viewfinder")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(Color.secondary.opacity(0.10), lineWidth: 1)
            )

            Spacer()
        }
        .padding(24)
    }

    private var statusMessage: String {
        switch status {
        case .notDetermined:
            return L("permission_message")
        case .denied:
            return L("permission_denied_message")
        case .restricted:
            return L("permission_restricted_message")
        case .authorized:
            return ""
        @unknown default:
            return L("permission_unknown_message")
        }
    }
}

private struct ManualBarcodeEntrySheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var barcode = ""
    @State private var errorMessage: String?

    let onSubmit: (String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(L("manual_barcode_hint")) {
                    TextField("", text: $barcode, prompt: Text(L("manual_barcode_field_label")))
                        .keyboardType(.numberPad)
                        .textContentType(.none)
                        .textInputAutocapitalization(.never)
                        .onChange(of: barcode) { _, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue {
                                barcode = filtered
                            }
                        }
                    if let errorMessage {
                        Text(errorMessage)
                            .appFont(.footnote)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(L("manual_barcode_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L("manual_barcode_cancel")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L("manual_barcode_submit")) {
                        submit()
                    }
                }
            }
        }
    }

    private func submit() {
        let value = barcode.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isPlausibleBarcode(value) else {
            errorMessage = L("manual_barcode_invalid")
            return
        }
        errorMessage = nil
        dismiss()
        onSubmit(value)
    }
}

private func isPlausibleBarcode(_ value: String) -> Bool {
    guard (8...14).contains(value.count) else { return false }
    return value.allSatisfy { $0.isNumber }
}

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafePalette = false

    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image(systemName: "leaf.circle.fill")
                        .appIconFont(size: 56, weight: .semibold)
                        .foregroundStyle(veganVerdictColor(for: .vegan, colorblindSafe: colorblindSafePalette))

                    Text(L("onboarding_title"))
                        .appFont(.title, weight: .bold)

                    Text(L("onboarding_message"))
                        .appFont(.body)
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 10) {
                        OnboardingLegendRow(
                            color: veganVerdictColor(for: .vegan, colorblindSafe: colorblindSafePalette),
                            text: L("vegan_verdict_vegan")
                        )
                        OnboardingLegendRow(
                            color: veganVerdictColor(for: .notVegan, colorblindSafe: colorblindSafePalette),
                            text: L("vegan_verdict_not_vegan")
                        )
                        OnboardingLegendRow(
                            color: veganVerdictColor(for: .maybe, colorblindSafe: colorblindSafePalette),
                            text: L("vegan_verdict_maybe")
                        )
                        OnboardingLegendRow(
                            color: veganVerdictColor(for: .unknown, colorblindSafe: colorblindSafePalette),
                            text: L("vegan_verdict_unknown")
                        )
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                    Button {
                        dismissAndMarkSeen()
                    } label: {
                        Text(L("onboarding_dismiss"))
                            .frame(maxWidth: .infinity)
                    }
                    .accessibilityIdentifier("onboarding-dismiss")
                    .buttonStyle(.borderedProminent)
                    .tint(Color("AccentColor"))
                }
                .padding()
            }
            .navigationTitle(L("app_name"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func dismissAndMarkSeen() {
        onDismiss()
        dismiss()
    }
}

private struct OnboardingLegendRow: View {
    let color: Color
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(color)
                .frame(width: 14, height: 14)
            Text(text)
                .appFont(.subheadline, weight: .semibold)
        }
    }
}

struct ResultView: View {
    let barcode: String
    let onContribute: (String, Product?, ProductSource?) -> Void
    let onSelectBarcode: (String) -> Void
    let onBack: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteProducts: [FavoriteProduct]
    @AppStorage(AllergenPreferences.selectedKeysKey) private var selectedAllergenStorage = ""
    @AppStorage(AllergenPreferences.strictModeKey) private var strictMode = false
    @AppStorage(WatchlistPreferences.additivesKey) private var watchedAdditivesStorage = ""
    @AppStorage(WatchlistPreferences.ingredientKeywordsKey) private var watchedKeywordsStorage = ""
    @State private var loadState: LoadState = .loading
    @State private var retrySeed = UUID()
    @State private var selectedAdditive: AdditiveEntry?
    @State private var selectedScoreInfo: ScoreExplanation?
    @State private var alternativesState: AlternativesState = .idle
    @State private var showingShareSheet = false
    @State private var shareTextForPresentation: String?
    @State private var shareImageForPresentation: UIImage?

    private let service = OpenFactsService()

    init(
        barcode: String,
        onContribute: @escaping (String, Product?, ProductSource?) -> Void,
        onSelectBarcode: @escaping (String) -> Void,
        onBack: @escaping () -> Void
    ) {
        self.barcode = barcode
        self.onContribute = onContribute
        self.onSelectBarcode = onSelectBarcode
        self.onBack = onBack
        _favoriteProducts = Query(filter: #Predicate<FavoriteProduct> { favorite in
            favorite.barcode == barcode
        })
    }

    private var selectedAllergenKeys: Set<String> {
        AllergenPreferences.decodeSelectedKeys(selectedAllergenStorage)
    }

    private var favoriteProduct: FavoriteProduct? {
        favoriteProducts.first
    }

    private var isFavorite: Bool {
        favoriteProduct != nil
    }

    var body: some View {
        content
            .navigationTitle(L("result_title"))
            .navigationBarTitleDisplayMode(.inline)
            .task(id: retrySeed) {
                await loadProduct()
            }
            .toolbar {
                if case .success = loadState {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            toggleFavorite()
                        } label: {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                        }
                        .accessibilityLabel(isFavorite ? L("favorite_remove_action") : L("favorite_add_action"))
                    }
                }
                if let shareText {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            prepareShare(text: shareText)
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .accessibilityLabel(L("share_action"))
                    }
                }
            }
            .sheet(item: $selectedAdditive) { additive in
                AdditiveInfoSheet(additive: additive)
            }
            .sheet(item: $selectedScoreInfo) { explanation in
                ScoreInfoSheet(explanation: explanation)
            }
            .sheet(isPresented: $showingShareSheet, onDismiss: {
                shareTextForPresentation = nil
                shareImageForPresentation = nil
            }) {
                ShareSheet(
                    items: [shareTextForPresentation, shareImageForPresentation].compactMap { $0 }
                )
            }
    }

    @ViewBuilder
    private var content: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            switch loadState {
            case .loading:
                LoadingStateView()
            case .notFound(let consultedSources):
                EmptyResultStateView(
                    icon: "magnifyingglass",
                    title: L("result_not_found_title"),
                    message: consultedSourcesMessage(consultedSources),
                    primaryActionTitle: L("contribute_product_action"),
                    primaryAction: { onContribute(barcode, nil, .openFoodFacts) },
                    secondaryActionTitle: L("retry"),
                    secondaryAction: { retrySeed = UUID() }
                )
            case .networkError(let message):
                ErrorStateView(
                    icon: "wifi.exclamationmark",
                    title: L("network_error_title"),
                    message: message,
                    actionTitle: L("retry"),
                    action: { retrySeed = UUID() }
                )
            case .success(let product, let source, let fromCache, let cachedAt):
                let allergenItems = buildAllergenDisplayItems(tags: product.allergensTags ?? [])
                let allergenMatches = buildProfileAllergenMatches(
                    product: product,
                    selectedKeys: selectedAllergenKeys,
                    strictMode: strictMode
                )
                let watchMatches = watchlistMatches(
                    product: product,
                    watchedAdditives: WatchlistPreferences.decode(watchedAdditivesStorage),
                    watchedKeywords: WatchlistPreferences.decode(watchedKeywordsStorage)
                )
                let facts = product.nutritionFacts
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        VeganBannerView(
                            analysis: analyzeVegan(product),
                            source: source,
                            fromCache: fromCache,
                            cachedAt: cachedAt
                        )

                        ProductHeaderCard(product: product, barcode: barcode)

                        if case .success(let alternatives) = alternativesState, !alternatives.isEmpty {
                            AlternativesSection(
                                products: alternatives,
                                onSelectBarcode: onSelectBarcode
                            )
                        } else if case .loading = alternativesState {
                            AlternativesLoadingSection()
                        }

                        if !allergenMatches.isEmpty {
                            AllergenWarningCard(matches: allergenMatches)
                        }
                        if !watchMatches.isEmpty {
                            WatchlistWarningCard(matches: watchMatches)
                        }

                        Button {
                            openProductOnOpenFoodFacts()
                        } label: {
                            Label(L("view_in_open_food_facts"), systemImage: "safari")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("AccentColor"))

                        Button {
                            onContribute(barcode, product, source)
                        } label: {
                            Label(L("contribute_product_action"), systemImage: "square.and.pencil")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        if let imageURLString = product.imageUrl, let url = URL(string: imageURLString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .fill(.quaternary)
                                        .overlay {
                                            ProgressView()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 220)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                case .failure:
                                    EmptyView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }

                        ScoresCard(
                            product: product,
                            onScoreTap: { selectedScoreInfo = $0 }
                        )
                        PalmOilCard(tags: product.ingredientsAnalysisTags)
                        IngredientsCard(
                            product: product,
                            watchedKeywords: watchMatches.ingredientKeywords
                        )
                        AdditivesCard(
                            product: product,
                            highlightedCodes: Set(watchMatches.additives),
                            onAdditiveTap: { selectedAdditive = $0 }
                        )
                        AllergensCard(
                            title: L("allergens_title"),
                            values: allergenItems,
                            highlightedKeys: Set(allergenMatches.compactMap(\.key))
                        )
                        SimpleSectionCard(
                            title: facts?.basis == .prepared
                                ? L("nutrition_title_prepared")
                                : L("nutrition_title")
                        ) {
                            NutritionGrid(product: product, facts: facts)
                        }

                        if let distribution = MacroDistribution(facts: facts) {
                            SimpleSectionCard(title: L("macro_distribution_title")) {
                                MacroDistributionView(distribution: distribution)
                            }
                        }

                        if let grade = product.nutriscoreGrade, !grade.isEmpty {
                            SimpleSectionCard(title: L("nutriscore_badge_title")) {
                                Button {
                                    selectedScoreInfo = ScoreExplanation(
                                        id: "nutriscore-detail",
                                        titleKey: "score_info_nutriscore_title",
                                        bodyKey: "score_info_nutriscore_body"
                                    )
                                } label: {
                                    NutriScoreBadgeView(grade: grade.uppercased())
                                }
                                .buttonStyle(.plain)
                                .accessibilityHint(L("score_info_tap_hint"))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                }
            }
        }
    }

    @MainActor
    private func loadProduct() async {
        loadState = .loading
        alternativesState = .idle
        let result = await service.fetchProduct(barcode: barcode)
        switch result {
        case .success(let fetched):
            saveToHistory(product: fetched.product)
            saveToCache(product: fetched.product, source: fetched.source)
            loadState = .success(fetched.product, fetched.source, false, nil)
            await loadAlternatives(for: fetched.product, source: fetched.source)
        case .notFound(let consultedSources):
            loadState = .notFound(consultedSources)
        case .error(let message):
            if let cached = loadCachedProduct() {
                saveToHistory(product: cached.product)
                loadState = .success(cached.product, cached.source, true, cached.cachedAt)
                await loadAlternatives(for: cached.product, source: cached.source)
            } else {
                loadState = .networkError(message)
            }
        }
    }

    private func loadAlternatives(for product: Product, source: ProductSource) async {
        let analysis = analyzeVegan(product)
        guard analysis.status != .vegan,
              let categoryTag = mostSpecificCategoryTag(product.categoriesTags) else {
            alternativesState = .unavailable
            return
        }

        alternativesState = .loading
        let alternatives = await service.fetchVeganAlternatives(
            categoryTag: categoryTag,
            source: source,
            excludingBarcode: barcode
        )
        alternativesState = alternatives.isEmpty ? .unavailable : .success(alternatives)
    }

    @MainActor
    private func saveToHistory(product: Product) {
        do {
            let descriptor = FetchDescriptor<ScanRecord>(predicate: #Predicate { $0.barcode == barcode })
            if let existing = try modelContext.fetch(descriptor).first {
                existing.productName = product.productName
                existing.brand = product.brands
                existing.imageURL = product.imageUrl
                existing.timestamp = Date()
            } else {
                modelContext.insert(ScanRecord(
                    barcode: barcode,
                    productName: product.productName,
                    brand: product.brands,
                    imageURL: product.imageUrl,
                    timestamp: Date()
                ))
            }
            try modelContext.save()
        } catch {
            print("No se pudo guardar el historial: \(error)")
        }
    }

    @MainActor
    private func saveToCache(product: Product, source: ProductSource) {
        do {
            let descriptor = FetchDescriptor<CachedProduct>(predicate: #Predicate { $0.barcode == barcode })
            let encoded = try JSONEncoder().encode(product)
            if let existing = try modelContext.fetch(descriptor).first {
                existing.productData = encoded
                existing.sourceName = source.rawValue
                existing.cachedAt = Date()
            } else {
                modelContext.insert(CachedProduct(
                    barcode: barcode,
                    productData: encoded,
                    sourceName: source.rawValue,
                    cachedAt: Date()
                ))
            }
            try modelContext.save()
            evictOldestCacheEntries()
        } catch {
            print("No se pudo guardar la caché: \(error)")
        }
    }

    private func loadCachedProduct() -> (product: Product, source: ProductSource, cachedAt: Date)? {
        do {
            let descriptor = FetchDescriptor<CachedProduct>(predicate: #Predicate { $0.barcode == barcode })
            guard let cached = try modelContext.fetch(descriptor).first else {
                return nil
            }
            if isCacheEntryExpired(cachedAt: cached.cachedAt) {
                modelContext.delete(cached)
                try modelContext.save()
                return nil
            }
            let product = try JSONDecoder().decode(Product.self, from: cached.productData)
            let source = ProductSource(rawValue: cached.sourceName) ?? .openFoodFacts
            return (product, source, cached.cachedAt)
        } catch {
            print("No se pudo cargar la caché: \(error)")
            return nil
        }
    }

    @MainActor
    private func evictOldestCacheEntries() {
        do {
            let entries = try modelContext.fetch(FetchDescriptor<CachedProduct>())
            let metadata = entries.map {
                CacheEntryMetadata(barcode: $0.barcode, cachedAt: $0.cachedAt)
            }
            let barcodes = cacheBarcodesToEvict(entries: metadata)
            entries.filter { barcodes.contains($0.barcode) }.forEach(modelContext.delete)
            if !barcodes.isEmpty {
                try modelContext.save()
            }
        } catch {
            print("No se pudo limitar la caché: \(error)")
        }
    }

    private func cleanTags(_ tags: [String]?) -> String {
        let cleaned = (tags ?? []).compactMap(cleanFoodFactsLabel)
        return cleaned.isEmpty ? L("not_available") : cleaned.joined(separator: ", ")
    }

    private func openProductOnOpenFoodFacts() {
        guard let url = URL(string: "https://world.openfoodfacts.org/product/\(barcode)") else {
            return
        }
        UIApplication.shared.open(url)
    }

    private func openAddProductOnOpenFoodFacts() {
        guard let url = URL(string: "https://world.openfoodfacts.org/cgi/product.pl?type=add&code=\(barcode)") else {
            return
        }
        UIApplication.shared.open(url)
    }

    @MainActor
    private func toggleFavorite() {
        guard case .success(let product, _, _, _) = loadState else {
            return
        }

        do {
            if let favoriteProduct {
                modelContext.delete(favoriteProduct)
            } else {
                modelContext.insert(FavoriteProduct(
                    barcode: barcode,
                    productName: product.productName,
                    brand: product.brands,
                    imageURL: product.imageUrl,
                    addedAt: Date()
                ))
            }
            try modelContext.save()
        } catch {
            print("No se pudo actualizar favoritos: \(error)")
        }
    }

    private var shareText: String? {
        guard case .success(let product, let source, _, _) = loadState else {
            return nil
        }
        return buildShareText(product: product, source: source)
    }

    private func buildShareText(product: Product, source: ProductSource) -> String {
        let title = product.productName?.trimmingCharacters(in: .whitespacesAndNewlines)
        let shareTitle = (title?.isEmpty == false ? title : nil) ?? barcode
        let verdict = shareVerdictLabel(for: analyzeVegan(product).status)
        let url = "https://world.openfoodfacts.org/product/\(barcode)"
        return String(format: L("share_result_template"), shareTitle, verdict, source.displayName, url)
    }

    @MainActor
    private func prepareShare(text: String) {
        shareTextForPresentation = text
        shareImageForPresentation = nil
        showingShareSheet = true
        guard
            case .success(let product, _, _, _) = loadState,
            let imageURLString = product.imageUrl,
            let imageURL = URL(string: imageURLString)
        else {
            return
        }

        Task { @MainActor in
            if let (data, _) = try? await URLSession.shared.data(from: imageURL) {
                shareImageForPresentation = UIImage(data: data)
            }
        }
    }

    private func shareVerdictLabel(for status: VeganStatus) -> String {
        switch status {
        case .vegan:
            return L("share_verdict_apto")
        case .notVegan:
            return L("share_verdict_no_apto")
        case .maybe:
            return L("share_verdict_dudoso")
        case .unknown:
            return L("share_verdict_sin_datos")
        }
    }

    private func consultedSourcesMessage(_ consultedSources: [ProductSource]) -> String {

        var seen = Set<String>()
        let names = consultedSources
            .map(\.displayName)
            .filter { seen.insert($0).inserted }

        guard !names.isEmpty else {
            return L("product_not_found")
        }
        return LF("product_not_found_sources", names.joined(separator: ", "))
    }
}

enum LoadState {
    case loading
    case notFound([ProductSource])
    case networkError(String)
    case success(Product, ProductSource, Bool, Date?)
}

private enum AlternativesState {
    case idle
    case loading
    case success([OpenFoodFactsSearchProduct])
    case unavailable
}

private struct AlternativesSection: View {
    let products: [OpenFoodFactsSearchProduct]
    let onSelectBarcode: (String) -> Void

    var body: some View {
        SimpleSectionCard(title: L("alternatives_title")) {
            VStack(spacing: 10) {
                ForEach(products.indices, id: \.self) { index in
                    let product = products[index]
                    if let code = product.code {
                        Button {
                            onSelectBarcode(code)
                        } label: {
                            HStack(spacing: 12) {
                                AlternativeThumbnail(imageURL: product.imageUrl)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.productName ?? L("alternative_unknown_product"))
                                        .appFont(.subheadline, weight: .semibold)
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.leading)
                                    if let brand = product.brands, !brand.isEmpty {
                                        Text(brand)
                                            .appFont(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

private struct AlternativesLoadingSection: View {
    var body: some View {
        SimpleSectionCard(title: L("alternatives_title")) {
            HStack(spacing: 10) {
                ProgressView()
                Text(L("alternatives_loading"))
                    .appFont(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct AlternativeThumbnail: View {
    let imageURL: String?

    var body: some View {
        Group {
            if let imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    if case .success(let image) = phase {
                        image.resizable().scaledToFill()
                    } else {
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: 58, height: 58)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(.quaternary)
            .overlay {
                Image(systemName: "leaf")
                    .foregroundStyle(.secondary)
            }
    }
}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScanRecord.timestamp, order: .reverse) private var records: [ScanRecord]
    @State private var query = ""
    @State private var sortOrder: ListSortOrder = .mostRecent
    @State private var showingClearConfirmation = false

    let onSelectBarcode: (String) -> Void
    let onScanProduct: () -> Void

    private var displayedRecords: [ScanRecord] {
        filterAndSortItems(
            records,
            query: query,
            sortOrder: sortOrder,
            productName: { $0.productName },
            brand: { $0.brand },
            barcode: { $0.barcode },
            timestamp: { $0.timestamp }
        )
    }

    var body: some View {
        List {
            if records.isEmpty {
                EmptyStateView(
                    icon: "clock.arrow.circlepath",
                    title: L("history_empty_title"),
                    message: L("history_empty_message"),
                    action: onScanProduct
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            } else if displayedRecords.isEmpty {
                EmptyStateView(
                    icon: "clock.arrow.circlepath",
                    title: L("history_empty_title"),
                    message: L("history_no_matches"),
                    action: nil
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            } else {
                ForEach(displayedRecords, id: \.barcode) { record in
                    Button {
                        onSelectBarcode(record.barcode)
                    } label: {
                        HistoryRow(record: record)
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            delete(record)
                        } label: {
                            Label(L("delete_action"), systemImage: "trash")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $query, prompt: L("history_search_hint"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                sortMenu
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showingClearConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .disabled(records.isEmpty)
                .accessibilityLabel(L("clear_history"))
            }
        }
        .confirmationDialog(
            L("clear_history_confirmation_title"),
            isPresented: $showingClearConfirmation,
            titleVisibility: .visible
        ) {
            Button(L("clear_history"), role: .destructive) {
                clearHistory()
            }
            Button(L("cancel"), role: .cancel) {}
        } message: {
            Text(L("clear_history_confirmation_message"))
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(L("history_title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var sortMenu: some View {
        Menu {
            Picker(L("sort_action"), selection: $sortOrder) {
                Text(L("sort_most_recent")).tag(ListSortOrder.mostRecent)
                Text(L("sort_name_az")).tag(ListSortOrder.nameAscending)
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
        .accessibilityLabel(L("sort_action"))
    }

    @MainActor
    private func delete(_ record: ScanRecord) {
        modelContext.delete(record)
        try? modelContext.save()
    }

    @MainActor
    private func clearHistory() {
        for record in records {
            modelContext.delete(record)
        }
        try? modelContext.save()
    }
}

private struct HistoryRow: View {
    let record: ScanRecord

    var body: some View {
        HStack(spacing: 14) {
            HistoryThumbnail(imageURLString: record.imageURL)

            VStack(alignment: .leading, spacing: 5) {
                Text(record.productName?.isEmpty == false ? record.productName! : record.barcode)
                    .appFont(.headline, weight: .semibold)
                    .foregroundStyle(.primary)

                if let brand = record.brand, !brand.isEmpty {
                    Text(brand)
                        .appFont(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(record.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .appFont(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            CapsuleChip(text: L("history_chip_open_result"), tint: .green)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.secondary.opacity(0.10), lineWidth: 1)
        )
    }
}

private struct HistoryThumbnail: View {
    let imageURLString: String?

    var body: some View {
        Group {
            if let imageURLString, let url = URL(string: imageURLString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.quaternary)
            Image(systemName: "photo")
                .appFont(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

private struct VeganBannerView: View {
    let analysis: VeganAnalysis
    let source: ProductSource
    let fromCache: Bool
    let cachedAt: Date?
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafePalette = false

    var body: some View {
        let spec = bannerSpec

        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: spec.symbol)
                    .appIconFont(size: 34, weight: .semibold)
                    .foregroundStyle(spec.foreground)

                VStack(alignment: .leading, spacing: 8) {
                    Text(spec.headline)
                        .appFont(.title2, weight: .bold)
                        .foregroundStyle(spec.foreground)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)

                    Text(spec.subtitle)
                        .appFont(.subheadline)
                        .foregroundStyle(spec.foreground.opacity(0.96))
                }
            }

            if let explanation = veganReasonText(analysis.reason) {
                Text(explanation)
                    .appFont(.subheadline)
                    .foregroundStyle(spec.foreground.opacity(0.96))
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel(explanation)
            }

            SourceCapsule(text: LF("data_source_label_format", source.displayName), foreground: spec.foreground)

            if fromCache {
                SourceCapsule(text: L("offline_cache_badge"), foreground: spec.foreground)
                if let cachedAt {
                    SourceCapsule(
                        text: cacheAgeText(cachedAt),
                        foreground: spec.foreground
                    )
                }
            }

            Text(L("open_food_facts_attribution"))
                .appFont(.caption2)
                .foregroundStyle(spec.foreground.opacity(0.9))

        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(spec.background)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: spec.background.opacity(0.24), radius: 12, x: 0, y: 8)
        .accessibilityElement(children: .combine)
    }

    private var bannerSpec: VeganBannerSpec {
        switch analysis.status {
        case .vegan:
            return VeganBannerSpec(
                headline: L("vegan_headline_vegan"),
                subtitle: L("vegan_verdict_vegan_subtitle"),
                background: veganVerdictColor(for: .vegan, colorblindSafe: colorblindSafePalette),
                foreground: .white,
                symbol: "checkmark.circle.fill"
            )
        case .notVegan:
            return VeganBannerSpec(
                headline: L("vegan_headline_not_vegan"),
                subtitle: analysis.heuristic
                    ? L("vegan_verdict_not_vegan_heuristic_subtitle")
                    : L("vegan_verdict_not_vegan_subtitle"),
                background: veganVerdictColor(for: .notVegan, colorblindSafe: colorblindSafePalette),
                foreground: .white,
                symbol: "xmark.circle.fill"
            )
        case .maybe:
            return VeganBannerSpec(
                headline: analysis.heuristic
                    ? L("vegan_headline_maybe_heuristic")
                    : L("vegan_headline_maybe"),
                subtitle: analysis.heuristic
                    ? L("vegan_verdict_maybe_heuristic_subtitle")
                    : L("vegan_verdict_maybe_subtitle"),
                background: veganVerdictColor(for: .maybe, colorblindSafe: colorblindSafePalette),
                foreground: .white,
                symbol: "exclamationmark.triangle.fill"
            )
        case .unknown:
            return VeganBannerSpec(
                headline: L("vegan_headline_unknown"),
                subtitle: L("vegan_verdict_unknown_subtitle"),
                background: veganVerdictColor(for: .unknown, colorblindSafe: colorblindSafePalette),
                foreground: .white,
                symbol: "questionmark.circle.fill"
            )
        }
    }
}

private func veganReasonText(_ reason: VeganReason?) -> String? {
    guard let reason else { return nil }
    let visibleEvidence = Array(reason.evidence.prefix(3))
    let evidence = visibleEvidence.joined(separator: ", ")
    let remaining = max(0, reason.evidence.count - visibleEvidence.count)
    let evidenceWithRemainder: String
    if remaining > 0 {
        let remainder = String(format: L("vegan_reason_more"), remaining)
        evidenceWithRemainder = [evidence, remainder]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    } else {
        evidenceWithRemainder = evidence
    }

    switch reason.source {
    case .structuredNonVeganIngredient:
        return String(format: L("vegan_reason_structured_non_vegan"), evidenceWithRemainder)
    case .structuredDoubtfulIngredient:
        return String(format: L("vegan_reason_structured_doubtful"), evidenceWithRemainder)
    case .structuredVeganIngredient:
        return L("vegan_reason_structured_vegan")
    case .decisiveTag:
        return L("vegan_reason_decisive_tag")
    case .heuristicText:
        return evidenceWithRemainder.isEmpty
            ? L("vegan_reason_heuristic_uncertain")
            : String(format: L("vegan_reason_heuristic"), evidenceWithRemainder)
    case .veganSeal:
        return L("vegan_reason_vegan_seal")
    case .meatAlternativeCategory:
        return L("vegan_reason_meat_category")
    case .additiveAnimal:
        return String(format: L("vegan_reason_additive_animal"), evidenceWithRemainder)
    case .additiveUncertain:
        return String(format: L("vegan_reason_additive_uncertain"), evidenceWithRemainder)
    }
}

private struct VeganBannerSpec {
    let headline: String
    let subtitle: String
    let background: Color
    let foreground: Color
    let symbol: String
}

private struct ProductHeaderCard: View {
    let product: Product
    let barcode: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(displayName)
                .appFont(.title, weight: .bold)
                .foregroundStyle(.primary)

            if let brands = product.brands, !brands.isEmpty {
                Text(String(format: L("brand_prefix"), brands))
                    .appFont(.headline)
                    .foregroundStyle(.secondary)
            }

            if let quantity = product.quantity, !quantity.isEmpty {
                Text(String(format: L("quantity_prefix"), quantity))
                    .appFont(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.secondary.opacity(0.10), lineWidth: 1)
        )
    }

    private var displayName: String {
        let trimmed = product.productName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? barcode : trimmed
    }
}

private struct IngredientsCard: View {
    let product: Product
    let watchedKeywords: [String]
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafePalette = false
    @State private var showTranslation = false

    var body: some View {
        if #available(iOS 17.4, *), let ingredientText {
            cardContent
                .translationPresentation(
                    isPresented: $showTranslation,
                    text: ingredientText
                )
        } else {
            cardContent
        }
    }

    private var ingredientText: String? {
        product.ingredientsText?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
            ? product.ingredientsText
            : nil
    }

    @ViewBuilder
    private var cardContent: some View {
        SimpleSectionCard(title: L("ingredients_title")) {
            let items = ingredientItems(for: product.ingredients)
            if let paragraph = ingredientParagraph(for: items, colorblindSafe: colorblindSafePalette) {
                VStack(alignment: .leading, spacing: 8) {
                    highlightedIngredientParagraph(
                        paragraph: paragraph,
                        items: items,
                        keywords: watchedKeywords,
                        colorblindSafe: colorblindSafePalette
                    )
                        .appFont(.body)
                        .foregroundStyle(.primary)
                        .accessibilityLabel(ingredientAccessibilityLabel(for: items))

                    if items.contains(where: { $0.1 == .animal || $0.1 == .doubtful }) {
                        Text(L("ingredients_legend"))
                            .appFont(.caption)
                            .foregroundStyle(.secondary)
                            .minimumScaleFactor(0.85)
                    }
                }
            } else {
                Text(product.ingredientsText?.isEmpty == false ? product.ingredientsText! : L("not_available"))
            }
            if #available(iOS 17.4, *), ingredientText != nil {
                Button {
                    showTranslation = true
                } label: {
                    Text(L("ingredients_translate_action"))
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

private func highlightedIngredientParagraph(
    paragraph: Text,
    items: [(String, IngredientKind)],
    keywords: [String],
    colorblindSafe: Bool
) -> Text {
    guard !keywords.isEmpty else { return paragraph }
    var result = Text("")
    for (index, item) in items.enumerated() {
        if index > 0 { result = result + Text(", ") }
        let normalized = normalizeWatchedKeyword(item.0)
        let isWatched = keywords.contains { normalized.contains(normalizeWatchedKeyword($0)) }
        var segment = Text(item.0)
        switch item.1 {
        case .animal:
            let color = veganVerdictColor(for: .notVegan, colorblindSafe: colorblindSafe)
            segment = segment.foregroundColor(color).bold().underline(true, color: color)
        case .doubtful:
            let color = veganVerdictColor(for: .maybe, colorblindSafe: colorblindSafe)
            segment = segment.foregroundColor(color).bold().underline(true, color: color)
        case .vegan, .unknown:
            break
        }
        if isWatched {
            segment = segment.bold().underline(true, color: Color("AccentColor"))
                .foregroundColor(Color("AccentColor"))
        }
        result = result + segment
    }
    return result
}

private func ingredientItems(for ingredients: [OffIngredient]?) -> [(String, IngredientKind)] {
    return (ingredients ?? []).compactMap { ingredient -> (String, IngredientKind)? in
        guard let label = cleanFoodFactsLabel(ingredient.text), !label.isEmpty else { return nil }
        let kind = IngredientKind(rawValue: ingredient.vegan?.lowercased() ?? "") ?? .unknown
        return (label, kind)
    }
}

private func ingredientParagraph(
    for items: [(String, IngredientKind)],
    colorblindSafe: Bool
) -> Text? {
    guard !items.isEmpty else { return nil }

    var paragraph = Text("")
    for (index, item) in items.enumerated() {
        if index > 0 {
            paragraph = paragraph + Text(", ")
        }

        let segment = Text(item.0)
        switch item.1 {
        case .animal:
            let color = veganVerdictColor(for: .notVegan, colorblindSafe: colorblindSafe)
            paragraph = paragraph + segment.foregroundColor(color).bold().underline(true, color: color)
        case .doubtful:
            let color = veganVerdictColor(for: .maybe, colorblindSafe: colorblindSafe)
            paragraph = paragraph + segment.foregroundColor(color).bold().underline(true, color: color)
        case .vegan, .unknown:
            paragraph = paragraph + segment
        }
    }

    return paragraph
}

private func ingredientAccessibilityLabel(for items: [(String, IngredientKind)]) -> String {
    items.map { label, kind in
        switch kind {
        case .animal:
            return "\(label), \(L("ingredient_status_animal"))"
        case .doubtful:
            return "\(label), \(L("ingredient_status_doubtful"))"
        case .vegan:
            return "\(label), \(L("ingredient_status_vegan"))"
        case .unknown:
            return "\(label), \(L("ingredient_status_unknown"))"
        }
    }.joined(separator: ", ")
}

private struct SimpleSectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .appFont(.headline, weight: .semibold)
                .foregroundStyle(.primary)

            content
                .appFont(.body)
                .foregroundStyle(.primary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.secondary.opacity(0.10), lineWidth: 1)
        )
    }
}

private struct AllergenWarningCard: View {
    let matches: [AllergenDisplayItem]

    var body: some View {
        let labels = matches.map(\.label).joined(separator: ", ")

        VStack(alignment: .leading, spacing: 10) {
            Text(L("allergen_warning_title"))
                .appFont(.headline, weight: .bold)
                .foregroundStyle(Color(red: 0.78, green: 0.16, blue: 0.16))

            Text(String(format: L("allergen_warning_message"), labels))
                .appFont(.body)
                .foregroundStyle(Color(red: 0.78, green: 0.16, blue: 0.16))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 1.0, green: 0.92, blue: 0.93))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct WatchlistWarningCard: View {
    let matches: WatchlistMatches

    var body: some View {
        let additiveLabels = matches.additives.joined(separator: ", ")
        let keywordLabels = matches.ingredientKeywords.joined(separator: ", ")
        VStack(alignment: .leading, spacing: 10) {
            Text(L("watchlist_warning_title"))
                .appFont(.headline, weight: .bold)
                .foregroundStyle(Color(red: 0.78, green: 0.16, blue: 0.16))

            if !matches.additives.isEmpty {
                Text(String(format: L("watchlist_warning_additives"), additiveLabels))
            }
            if !matches.ingredientKeywords.isEmpty {
                Text(String(format: L("watchlist_warning_keywords"), keywordLabels))
            }
        }
        .appFont(.body)
        .foregroundStyle(Color(red: 0.78, green: 0.16, blue: 0.16))
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 1.0, green: 0.92, blue: 0.93))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct AllergensCard: View {
    let title: String
    let values: [AllergenDisplayItem]
    let highlightedKeys: Set<String>

    var body: some View {
        SimpleSectionCard(title: title) {
            if values.isEmpty {
                Text(L("not_available"))
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(values) { item in
                        CapsuleChip(
                            text: item.label,
                            tint: highlightedKeys.contains(item.key ?? "") ? .red : .secondary
                        )
                    }
                }
            }
        }
    }
}

private struct SourceCapsule: View {
    let text: String
    let foreground: Color

    var body: some View {
        Text(text)
            .appFont(.caption, weight: .semibold)
            .foregroundStyle(foreground)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(foreground.opacity(0.14))
            .clipShape(Capsule())
    }
}

private struct CapsuleChip: View {
    let text: String
    let tint: Color

    var body: some View {
        Text(text)
            .appFont(.caption, weight: .semibold)
            .foregroundStyle(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(tint.opacity(0.14))
            .clipShape(Capsule())
    }
}

private struct LoadingStateView: View {
    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                ProgressView()
                Text(L("loading_product"))
                    .appFont(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(28)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding()

            Spacer()
        }
    }
}

private struct EmptyResultStateView: View {
    let icon: String
    let title: String
    let message: String
    let primaryActionTitle: String
    let primaryAction: () -> Void
    let secondaryActionTitle: String?
    let secondaryAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .appIconFont(size: 42, weight: .semibold)
                .foregroundStyle(.green)

            Text(title)
                .appFont(.title2, weight: .bold)
                .multilineTextAlignment(.center)

            Text(message)
                .appFont(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(primaryActionTitle, action: primaryAction)
                .buttonStyle(.borderedProminent)
                .tint(Color("AccentColor"))

            if let secondaryActionTitle, let secondaryAction {
                Button(secondaryActionTitle, action: secondaryAction)
                    .buttonStyle(.bordered)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding()
    }
}

private struct ErrorStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .appIconFont(size: 42, weight: .semibold)
                .foregroundStyle(.red)

            Text(title)
                .appFont(.title2, weight: .bold)
                .multilineTextAlignment(.center)

            Text(message)
                .appFont(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(actionTitle, action: action)
                .buttonStyle(.borderedProminent)
                .tint(Color("AccentColor"))
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding()
    }
}

private enum IngredientKind: String {
    case vegan = "yes"
    case animal = "no"
    case doubtful = "maybe"
    case unknown

    func spec(colorblindSafe: Bool) -> IngredientKindSpec {
        switch self {
        case .vegan:
            let color = veganVerdictColor(for: .vegan, colorblindSafe: colorblindSafe)
            return IngredientKindSpec(
                label: L("ingredient_status_vegan"),
                accent: color,
                rowBackground: color.opacity(0.10)
            )
        case .animal:
            let color = veganVerdictColor(for: .notVegan, colorblindSafe: colorblindSafe)
            return IngredientKindSpec(
                label: L("ingredient_status_animal"),
                accent: color,
                rowBackground: color.opacity(0.10)
            )
        case .doubtful:
            let color = veganVerdictColor(for: .maybe, colorblindSafe: colorblindSafe)
            return IngredientKindSpec(
                label: L("ingredient_status_doubtful"),
                accent: color,
                rowBackground: color.opacity(0.10)
            )
        case .unknown:
            return IngredientKindSpec(
                label: L("ingredient_status_unknown"),
                accent: .secondary,
                rowBackground: Color.secondary.opacity(0.10)
            )
        }
    }
}

private struct IngredientKindSpec {
    let label: String
    let accent: Color
    let rowBackground: Color
}

private struct NutritionGrid: View {
    let product: Product
    let facts: NutritionFacts?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if facts?.basis == .prepared {
                Text(L("nutrition_prepared_note"))
                    .appFont(.body)
                    .foregroundStyle(.secondary)
            }
            if let facts {
                NutritionRow(label: L("nutrition_energy"), value: energyRowValue(facts))
                NutritionRow(label: L("nutrition_fat"), value: format(facts.fat, unit: "g"))
                NutritionRow(label: L("nutrition_saturated_fat"), value: format(facts.saturatedFat, unit: "g"))
                NutritionRow(label: L("nutrition_carbohydrates"), value: format(facts.carbohydrates, unit: "g"))
                NutritionRow(label: L("nutrition_sugars"), value: format(facts.sugars, unit: "g"))
                if let addedSugars = facts.addedSugars, addedSugars >= 0 {
                    let formatted = formatNumber(addedSugars)
                    NutritionRow(
                        label: L("nutrition_added_sugars"),
                        value: LF("nutrition_added_sugars_value", formatted, formatted)
                    )
                }
                NutritionRow(label: L("nutrition_salt"), value: format(facts.salt, unit: "g"))
                NutritionRow(label: L("nutrition_proteins"), value: format(facts.proteins, unit: "g"))
            } else {
                Text(L("nutrition_unavailable"))
                    .appFont(.body)
            }
            if !product.nutrientLevelEntries.isEmpty {
                Text(L("nutrient_levels_title"))
                    .appFont(.headline, weight: .semibold)
                    .foregroundStyle(Color("AccentColor"))
                    .padding(.top, 4)
                ForEach(Array(product.nutrientLevelEntries.enumerated()), id: \.offset) { _, entry in
                    let label = nutrientLevelLabel(entry.key)
                    let level = nutrientLevelText(entry.level)
                    HStack {
                        Text(label)
                        Spacer()
                        Text(level)
                            .appFont(.footnote, weight: .semibold)
                            .foregroundStyle(nutrientLevelColors(entry.level).foreground)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(nutrientLevelColors(entry.level).background)
                            .clipShape(Capsule())
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(LF("nutrient_level_content_description", label, level))
                }
            }
        }
    }

    private func formatNumber(_ value: Double) -> String {
        if value.rounded() == value {
            return "\(Int(value))"
        }
        return String(format: "%.1f", value)
    }

    private func format(_ value: Double?, unit: String) -> String {
        guard let value else { return L("not_available") }
        if value.rounded() == value {
            return "\(Int(value)) \(unit)"
        }
        return String(format: "%.1f %@", value, unit)
    }

    private func energyRowValue(_ facts: NutritionFacts) -> String {
        if let energyKcal = facts.energyKcal {
            return format(energyKcal, unit: "kcal")
        }
        return format(facts.energyKj, unit: "kJ")
    }

    private func nutrientLevelLabel(_ key: NutrientLevelKey) -> String {
        switch key {
        case .fat:
            return L("nutrition_fat")
        case .saturatedFat:
            return L("nutrition_saturated_fat")
        case .sugars:
            return L("nutrition_sugars")
        case .salt:
            return L("nutrition_salt")
        }
    }

    private func nutrientLevelText(_ level: NutrientLevelValue) -> String {
        switch level {
        case .low:
            return L("nutrient_level_low")
        case .moderate:
            return L("nutrient_level_moderate")
        case .high:
            return L("nutrient_level_high")
        }
    }
}

private struct MacroDistribution {
    let proteins: Double
    let fats: Double
    let carbohydrates: Double
    let total: Double

    init?(facts: NutritionFacts?) {
        guard
            let proteins = facts?.proteins,
            let fats = facts?.fat,
            let carbohydrates = facts?.carbohydrates
        else {
            return nil
        }

        let safeProteins = max(proteins, 0)
        let safeFats = max(fats, 0)
        let safeCarbohydrates = max(carbohydrates, 0)
        let total = safeProteins + safeFats + safeCarbohydrates
        guard total > 0 else { return nil }

        self.proteins = safeProteins
        self.fats = safeFats
        self.carbohydrates = safeCarbohydrates
        self.total = total
    }

    var segments: [MacroSegment] {
        [
            MacroSegment(
                label: L("macro_proteins_label"),
                grams: proteins,
                share: proteins / total,
                color: Color(red: 0.18, green: 0.49, blue: 0.20),
                foreground: .white
            ),
            MacroSegment(
                label: L("macro_fat_label"),
                grams: fats,
                share: fats / total,
                color: Color(red: 0.96, green: 0.66, blue: 0.00),
                foreground: Color(red: 0.15, green: 0.18, blue: 0.20)
            ),
            MacroSegment(
                label: L("macro_carbohydrates_label"),
                grams: carbohydrates,
                share: carbohydrates / total,
                color: Color(red: 0.08, green: 0.39, blue: 0.74),
                foreground: .white
            ),
        ]
    }
}

private struct MacroSegment: Identifiable {
    let label: String
    let grams: Double
    let share: Double
    let color: Color
    let foreground: Color

    var id: String { label }
}

private struct MacroDistributionView: View {
    let distribution: MacroDistribution

    var body: some View {
        let segments = distribution.segments
        VStack(alignment: .leading, spacing: 10) {
            Chart(segments) { segment in
                SectorMark(
                    angle: .value(segment.label, segment.share),
                    innerRadius: .ratio(0.6),
                    angularInset: 1.2
                )
                .foregroundStyle(segment.color)
            }
            .frame(height: 184)
            .chartLegend(.hidden)
            .accessibilityLabel(
                LF(
                    "macro_chart_content_description",
                    formatMacroValue(distribution.proteins),
                    formatMacroPercent(segments[0].share),
                    formatMacroValue(distribution.fats),
                    formatMacroPercent(segments[1].share),
                    formatMacroValue(distribution.carbohydrates),
                    formatMacroPercent(segments[2].share)
                )
            )

            VStack(alignment: .leading, spacing: 6) {
                ForEach(segments) { segment in
                    MacroLegendRow(segment: segment)
                }
            }
        }
    }
}

private struct MacroLegendRow: View {
    let segment: MacroSegment

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(segment.color)
                .frame(width: 12, height: 12)
                .padding(.top, 4)

            Text(
                LF(
                    "macro_legend_format",
                    segment.label,
                    formatMacroValue(segment.grams),
                    formatMacroPercent(segment.share)
                )
            )
            .appFont(.footnote)
            .foregroundStyle(.secondary)

            Spacer(minLength: 0)
        }
    }
}

private struct NutriScoreBadgeView: View {
    let grade: String

    var body: some View {
        let colors = nutriScoreColors(grade)
        Text(grade)
            .appFont(.title3, weight: .bold)
            .foregroundStyle(colors.foreground)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(colors.background)
            )
            .accessibilityLabel(LF("nutriscore_badge_content_description", grade))
    }
}

private struct NutriScoreColors {
    let background: Color
    let foreground: Color
}

private func nutriScoreColors(_ grade: String) -> NutriScoreColors {
    switch grade.uppercased() {
    case "A":
        return NutriScoreColors(background: Color(red: 0.18, green: 0.49, blue: 0.20), foreground: .white)
    case "B":
        return NutriScoreColors(background: Color(red: 0.49, green: 0.70, blue: 0.20), foreground: Color(red: 0.15, green: 0.18, blue: 0.20))
    case "C":
        return NutriScoreColors(background: Color(red: 0.99, green: 0.85, blue: 0.16), foreground: Color(red: 0.15, green: 0.18, blue: 0.20))
    case "D":
        return NutriScoreColors(background: Color(red: 0.96, green: 0.49, blue: 0.00), foreground: .white)
    case "E":
        return NutriScoreColors(background: Color(red: 0.76, green: 0.16, blue: 0.16), foreground: .white)
    default:
        return NutriScoreColors(background: Color.secondary.opacity(0.2), foreground: .primary)
    }
}

private func formatMacroValue(_ value: Double) -> String {
    if value.rounded() == value {
        return String(format: "%.0f", value)
    }
    return String(format: "%.1f", value)
}

private func formatMacroPercent(_ value: Double) -> String {
    String(format: "%.0f", value * 100)
}

private struct NutritionRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .layoutPriority(1)
            Spacer()
            Text(value)
                .appFont(.body, weight: .semibold)
                .multilineTextAlignment(.trailing)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label), \(value)")
    }
}

private struct ScoreExplanation: Identifiable {
    let id: String
    let titleKey: String
    let bodyKey: String
}

private struct ScoresCard: View {
    let product: Product
    let onScoreTap: (ScoreExplanation) -> Void

    var body: some View {
        let nutriScore = normalizedScore(product.nutriscoreGrade)
        let greenScore = product.greenScoreGrade
        let greenScoreValue = product.greenScoreValue
        let novaGroup = product.novaGroup.flatMap { (1...4).contains($0) ? $0 : nil }
        let carbonFootprint = product.carbonFootprint

        return Group {
            if nutriScore == nil && greenScore == nil && novaGroup == nil && carbonFootprint == nil {
                EmptyView()
            } else {
                SimpleSectionCard(title: L("product_scores_title")) {
                    HStack(alignment: .top, spacing: 16) {
                        if let nutriScore {
                            Button {
                                onScoreTap(
                                    ScoreExplanation(
                                        id: "nutriscore",
                                        titleKey: "score_info_nutriscore_title",
                                        bodyKey: "score_info_nutriscore_body"
                                    )
                                )
                            } label: {
                                ScoreColumn(label: L("nutriscore_badge_title")) {
                                    NutriScoreBadgeView(grade: nutriScore)
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint(L("score_info_tap_hint"))
                        }
                        if let greenScore {
                            Button {
                                onScoreTap(
                                    ScoreExplanation(
                                        id: "green-score",
                                        titleKey: "score_info_green_score_title",
                                        bodyKey: "score_info_green_score_body"
                                    )
                                )
                            } label: {
                                ScoreColumn(label: L("green_score_badge_title")) {
                                    VStack(spacing: 6) {
                                        GreenScoreBadgeView(grade: greenScore)
                                        if let greenScoreValue {
                                            Text(LF("green_score_value", greenScoreValue))
                                                .appFont(.caption)
                                        }
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint(L("score_info_tap_hint"))
                        }
                        if let novaGroup {
                            Button {
                                onScoreTap(
                                    ScoreExplanation(
                                        id: "nova",
                                        titleKey: "score_info_nova_title",
                                        bodyKey: "score_info_nova_body"
                                    )
                                )
                            } label: {
                                ScoreColumn(label: L("nova_group_badge_title")) {
                                    NovaGroupBadgeView(group: novaGroup)
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint(L("score_info_tap_hint"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    if let carbonFootprint {
                        let source = carbonFootprintSourceText(carbonFootprint.source)
                        let value = LF(
                            "carbon_footprint_value",
                            formatCarbonFootprint(carbonFootprint.value)
                        )
                        Button {
                            onScoreTap(
                                ScoreExplanation(
                                    id: "carbon-footprint",
                                    titleKey: "score_info_carbon_footprint_title",
                                    bodyKey: "score_info_carbon_footprint_body"
                                )
                            )
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(L("carbon_footprint_title"))
                                        .appFont(.footnote, weight: .semibold)
                                    Text(value)
                                        .appFont(.subheadline, weight: .semibold)
                                }
                                Spacer()
                                Text(source)
                                    .appFont(.caption)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(
                            "\(L("carbon_footprint_title")), \(value), \(source)"
                        )
                        .accessibilityHint(L("score_info_tap_hint"))
                    }
                }
            }
        }
    }
}

private struct ScoreInfoSheet: View {
    let explanation: ScoreExplanation

    var body: some View {
        ScrollView {
            SimpleSectionCard(title: L(explanation.titleKey)) {
                Text(L(explanation.bodyKey))
            }
            .padding()
        }
        .presentationDetents([.medium, .large])
    }
}

private struct PalmOilCard: View {
    let tags: [String]?

    var body: some View {
        if let status = palmOilStatus(tags) {
            let colors = palmOilColors(status)
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "leaf")
                        .foregroundStyle(colors.accent)
                    Text(L("palm_oil_title"))
                        .appFont(.headline, weight: .bold)
                        .foregroundStyle(colors.accent)
                }
                Text(palmOilStatusText(status))
                    .appFont(.body, weight: .semibold)
                    .foregroundStyle(colors.text)
                Text(L("palm_oil_note"))
                    .appFont(.body)
                    .foregroundStyle(colors.text.opacity(0.85))
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colors.background)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
    }
}

private struct PalmOilColors {
    let background: Color
    let accent: Color
    let text: Color
}

private func palmOilColors(_ status: PalmOilStatus) -> PalmOilColors {
    switch status {
    case .present:
        return PalmOilColors(
            background: Color(red: 1.0, green: 0.95, blue: 0.88),
            accent: Color(red: 0.90, green: 0.32, blue: 0.00),
            text: Color(red: 0.11, green: 0.11, blue: 0.12)
        )
    case .maybe:
        return PalmOilColors(
            background: Color(red: 1.0, green: 0.97, blue: 0.88),
            accent: Color(red: 0.55, green: 0.43, blue: 0.00),
            text: Color(red: 0.11, green: 0.11, blue: 0.12)
        )
    case .free:
        return PalmOilColors(
            background: Color(red: 0.91, green: 0.97, blue: 0.92),
            accent: Color(red: 0.18, green: 0.49, blue: 0.20),
            text: Color(red: 0.11, green: 0.11, blue: 0.12)
        )
    }
}

private func palmOilStatusText(_ status: PalmOilStatus) -> String {
    switch status {
    case .present:
        return L("palm_oil_present")
    case .maybe:
        return L("palm_oil_maybe")
    case .free:
        return L("palm_oil_free")
    }
}

private func normalizedScore(_ value: String?) -> String? {
    let normalized = value?
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .uppercased()
    guard let normalized, !normalized.isEmpty else {
        return nil
    }
    return normalized
}

private struct NutrientLevelColors {
    let background: Color
    let foreground: Color
}

private func nutrientLevelColors(_ level: NutrientLevelValue) -> NutrientLevelColors {
    switch level {
    case .low:
        return NutrientLevelColors(
            background: Color(red: 0.180, green: 0.490, blue: 0.196),
            foreground: .white
        )
    case .moderate:
        return NutrientLevelColors(
            background: Color(red: 0.976, green: 0.659, blue: 0.145),
            foreground: Color(red: 0.122, green: 0.161, blue: 0.216)
        )
    case .high:
        return NutrientLevelColors(
            background: Color(red: 0.776, green: 0.157, blue: 0.157),
            foreground: .white
        )
    }
}

private func carbonFootprintSourceText(_ source: CarbonFootprintSource) -> String {
    switch source {
    case .declared:
        return L("carbon_footprint_source_declared")
    case .estimated:
        return L("carbon_footprint_source_estimated")
    }
}

private func formatCarbonFootprint(_ value: Double) -> String {
    if value >= 10 {
        return String(format: "%.0f", value)
    }
    return String(format: "%.1f", value)
}

private struct ScoreColumn<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Text(label)
                .appFont(.footnote, weight: .semibold)
                .multilineTextAlignment(.center)
            content
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

private struct GreenScoreBadgeView: View {
    let grade: String

    var body: some View {
        let colors = nutriScoreColors(grade)
        Text(grade)
            .appFont(.title3, weight: .bold)
            .foregroundStyle(colors.foreground)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(colors.background)
            )
            .accessibilityLabel(LF("green_score_badge_content_description", grade))
    }
}

private struct NovaGroupBadgeView: View {
    let group: Int

    var body: some View {
        let colors = novaGroupColors(group)
        Text("\(L("nova_group_badge_title")) \(group)")
            .appFont(.subheadline, weight: .bold)
            .foregroundStyle(colors.foreground)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(colors.background)
            .clipShape(Capsule())
            .accessibilityLabel(LF("nova_group_badge_content_description", group))
    }
}

private func novaGroupColors(_ group: Int) -> NutriScoreColors {
    switch group {
    case 1:
        return NutriScoreColors(background: Color(red: 0.18, green: 0.49, blue: 0.20), foreground: .white)
    case 2:
        return NutriScoreColors(background: Color(red: 0.49, green: 0.70, blue: 0.20), foreground: Color(red: 0.15, green: 0.18, blue: 0.20))
    case 3:
        return NutriScoreColors(background: Color(red: 0.96, green: 0.49, blue: 0.00), foreground: .white)
    case 4:
        return NutriScoreColors(background: Color(red: 0.76, green: 0.16, blue: 0.16), foreground: .white)
    default:
        return NutriScoreColors(background: Color.secondary.opacity(0.2), foreground: .primary)
    }
}

private struct AdditivesCard: View {
    let product: Product
    let highlightedCodes: Set<String>
    let onAdditiveTap: (AdditiveEntry) -> Void

    var body: some View {
        let items = additiveDisplayItems(for: product.additivesTags)
        SimpleSectionCard(title: L("additives_title")) {
            if items.isEmpty {
                Text(L("not_available"))
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(items) { item in
                        if let additive = item.additive {
                            Button {
                                onAdditiveTap(additive)
                            } label: {
                                AdditiveChipView(item: item, highlighted: highlightedCodes.contains(item.code))
                            }
                            .buttonStyle(.plain)
                        } else {
                            AdditiveChipView(item: item, highlighted: highlightedCodes.contains(item.code))
                        }
                    }
                }
            }
        }
    }
}

private struct AdditiveDisplayItem: Identifiable {
    let code: String
    let additive: AdditiveEntry?

    var id: String { code }
}

private func additiveDisplayItems(for tags: [String]?) -> [AdditiveDisplayItem] {
    var seen = Set<String>()
    return (tags ?? []).compactMap { tag in
        guard let code = cleanFoodFactsLabel(tag)?.uppercased(), seen.insert(code).inserted else {
            return nil
        }
        return AdditiveDisplayItem(code: code, additive: additiveEntry(for: code))
    }
}

private struct AdditiveChipView: View {
    let item: AdditiveDisplayItem
    let highlighted: Bool

    var body: some View {
        let name = item.additive?.info.commonName?.trimmingCharacters(in: .whitespacesAndNewlines)
        let label = name.flatMap { $0.isEmpty ? nil : "\(item.code) · \($0)" } ?? item.code
        let colors = highlighted
            ? AdditiveBadgeColors(background: Color("AccentColor").opacity(0.18), content: Color("AccentColor"))
            : item.additive.map { additiveOriginColors($0.info.origin) } ?? AdditiveBadgeColors(background: Color(.secondarySystemBackground), content: .secondary)
        Text(label)
            .appFont(.subheadline, weight: .semibold)
            .foregroundStyle(colors.content)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(colors.background)
            .clipShape(Capsule())
    }
}

private struct AdditiveInfoSheet: View {
    let additive: AdditiveEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                let colors = additiveOriginColors(additive.info.origin)
                VStack(alignment: .leading, spacing: 8) {
                    Text(additive.code)
                        .appFont(.headline)
                        .foregroundStyle(colors.content)
                    Text(additive.info.commonName ?? L("additive_unknown_name"))
                        .appFont(.title2, weight: .bold)
                        .foregroundStyle(colors.content)
                    Text(additiveOriginLabel(additive.info.origin))
                        .appFont(.subheadline, weight: .semibold)
                        .foregroundStyle(colors.content)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(colors.background)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                if !additive.info.note.isEmpty {
                    SimpleSectionCard(title: L("additive_origin_label")) {
                        Text(additive.info.note)
                    }
                }
            }
            .padding()
        }
        .presentationDetents([.medium, .large])
    }
}

private func additiveOriginLabel(_ origin: AdditiveOrigin) -> String {
    switch origin {
    case .animal:
        return L("additive_origin_animal")
    case .plant:
        return L("additive_origin_plant")
    case .synthetic:
        return L("additive_origin_synthetic")
    case .uncertain:
        return L("additive_origin_uncertain")
    case .unknown:
        return L("additive_origin_no_data")
    }
}

private func additiveOriginColors(_ origin: AdditiveOrigin) -> AdditiveBadgeColors {
    switch origin {
    case .animal:
        return AdditiveBadgeColors(background: Color(red: 1.0, green: 0.92, blue: 0.93), content: Color(red: 0.78, green: 0.15, blue: 0.16))
    case .plant:
        return AdditiveBadgeColors(background: Color(red: 0.91, green: 0.96, blue: 0.91), content: Color(red: 0.18, green: 0.49, blue: 0.20))
    case .synthetic:
        return AdditiveBadgeColors(background: Color(red: 0.89, green: 0.95, blue: 0.99), content: Color(red: 0.08, green: 0.39, blue: 0.74))
    case .uncertain:
        return AdditiveBadgeColors(background: Color(red: 1.0, green: 0.95, blue: 0.88), content: Color(red: 0.70, green: 0.42, blue: 0.00))
    case .unknown:
        return AdditiveBadgeColors(background: Color(red: 0.91, green: 0.91, blue: 0.93), content: Color(red: 0.28, green: 0.34, blue: 0.45))
    }
}

private struct AdditiveBadgeColors {
    let background: Color
    let content: Color
}

private struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}
