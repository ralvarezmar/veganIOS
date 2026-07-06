import Foundation
import SwiftUI
import SwiftData
import AVFoundation
import UIKit

struct ScannerView: View {
    @Binding var isScannerRunning: Bool
    let onDetectedBarcode: (String) -> Void

    @State private var authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    @State private var isRequestingAccess = false
    @State private var detectedBarcode: String?
    @State private var showingDetectionConfirmation = false
    @State private var pendingNavigationTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            if authorizationStatus == .authorized {
                BarcodeScannerView(isRunning: $isScannerRunning) { barcode in
                    handleDetection(barcode)
                }
                .ignoresSafeArea()

                ScannerOverlayView(showingDetectionConfirmation: showingDetectionConfirmation)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            } else {
                CameraPermissionView(
                    status: authorizationStatus,
                    isRequestingAccess: isRequestingAccess,
                    onRequestAccess: requestCameraAccess,
                    onOpenSettings: openSettings
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

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

private struct ScannerOverlayView: View {
    let showingDetectionConfirmation: Bool

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

                    HelperCardView()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

private struct HelperCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Apunta al código de barras")
                .font(.headline)
                .fontWeight(.semibold)
            Text("Se admiten códigos EAN y UPC.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
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
                .font(.title3.weight(.semibold))
            VStack(alignment: .leading, spacing: 2) {
                Text("Código detectado")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text("Abriendo el resultado…")
                    .font(.caption)
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

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            VStack(spacing: 18) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundStyle(Color.green)

                Text("Permiso de cámara necesario")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text(statusMessage)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                if status == .notDetermined {
                    Button {
                        onRequestAccess()
                    } label: {
                        Label(isRequestingAccess ? "Solicitando…" : "Conceder permiso", systemImage: "camera.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .disabled(isRequestingAccess)
                } else {
                    Button {
                        onOpenSettings()
                    } label: {
                        Label("Abrir ajustes", systemImage: "gearshape")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
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
            return "Necesitamos la cámara para escanear códigos de barras."
        case .denied:
            return "La cámara está desactivada para esta app. Puedes habilitarla en Ajustes."
        case .restricted:
            return "El acceso a la cámara está restringido en este dispositivo."
        case .authorized:
            return ""
        @unknown default:
            return "No se pudo determinar el estado de la cámara."
        }
    }
}

struct ResultView: View {
    let barcode: String
    let onBack: () -> Void

    @Environment(\.modelContext) private var modelContext
    @State private var loadState: LoadState = .loading
    @State private var retrySeed = UUID()

    private let service = OpenFactsService()

    var body: some View {
        content
            .navigationTitle("Resultado")
            .navigationBarTitleDisplayMode(.inline)
            .task(id: retrySeed) {
                await loadProduct()
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
                    title: "Sin datos suficientes",
                    message: consultedSourcesMessage(consultedSources),
                    actionTitle: "Reintentar",
                    action: { retrySeed = UUID() }
                )
            case .networkError(let message):
                ErrorStateView(
                    icon: "wifi.exclamationmark",
                    title: "No hemos podido consultar las bases de datos",
                    message: message,
                    actionTitle: "Reintentar",
                    action: { retrySeed = UUID() }
                )
            case .success(let product, let source):
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        VeganBannerView(analysis: analyzeVegan(product), source: source)

                        ProductHeaderCard(product: product, barcode: barcode)

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

                        IngredientsCard(product: product)
                        SimpleSectionCard(title: "Aditivos") {
                            Text(cleanTags(product.additivesTags))
                        }
                        SimpleSectionCard(title: "Alérgenos") {
                            Text(cleanTags(product.allergensTags))
                        }
                        SimpleSectionCard(title: "Nutrición básica por 100 g") {
                            NutritionGrid(nutriments: product.nutriments)
                        }

                        if let grade = product.nutriscoreGrade, !grade.isEmpty {
                            SimpleSectionCard(title: "Nutri-Score") {
                                Text(grade.uppercased())
                                    .font(.headline.bold())
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
        let result = await service.fetchProduct(barcode: barcode)
        switch result {
        case .success(let fetched):
            saveToHistory(product: fetched.product)
            loadState = .success(fetched.product, fetched.source)
        case .notFound(let consultedSources):
            loadState = .notFound(consultedSources)
        case .error(let message):
            loadState = .networkError(message)
        }
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

    private func cleanTags(_ tags: [String]?) -> String {
        let cleaned = (tags ?? []).compactMap(cleanFoodFactsLabel)
        return cleaned.isEmpty ? "—" : cleaned.joined(separator: ", ")
    }

    private func consultedSourcesMessage(_ consultedSources: [ProductSource]) -> String {
        var seen = Set<String>()
        let names = consultedSources
            .map(\.displayName)
            .filter { seen.insert($0).inserted }

        guard !names.isEmpty else {
            return "Producto no encontrado en Open Food Facts"
        }
        return "No se ha encontrado información suficiente en ninguna de las bases consultadas: \(names.joined(separator: ", "))."
    }
}

enum LoadState {
    case loading
    case notFound([ProductSource])
    case networkError(String)
    case success(Product, ProductSource)
}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScanRecord.timestamp, order: .reverse) private var records: [ScanRecord]
    @State private var showingClearConfirmation = false

    let onSelectBarcode: (String) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if records.isEmpty {
                    VStack(spacing: 14) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 42, weight: .semibold))
                            .foregroundStyle(.green)

                        Text("Historial vacío")
                            .font(.title2.bold())

                        Text("Escanea un producto para ver aquí tus consultas recientes.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(28)
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .padding(.top, 64)
                } else {
                    ForEach(records, id: \.barcode) { record in
                        Button {
                            onSelectBarcode(record.barcode)
                        } label: {
                            HistoryRow(record: record)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Historial")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showingClearConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .disabled(records.isEmpty)
            }
        }
        .confirmationDialog("¿Limpiar historial?", isPresented: $showingClearConfirmation, titleVisibility: .visible) {
            Button("Limpiar historial", role: .destructive) {
                clearHistory()
            }
            Button("Cancelar", role: .cancel) {}
        }
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
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                if let brand = record.brand, !brand.isEmpty {
                    Text(brand)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(record.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            CapsuleChip(text: "Ver veredicto", tint: .green)
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
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

private struct VeganBannerView: View {
    let analysis: VeganAnalysis
    let source: ProductSource

    var body: some View {
        let spec = bannerSpec

        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: spec.symbol)
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(spec.foreground)

                VStack(alignment: .leading, spacing: 8) {
                    Text(spec.headline)
                        .font(.title2.bold())
                        .foregroundStyle(spec.foreground)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)

                    Text(spec.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(spec.foreground.opacity(0.96))
                }
            }

            SourceCapsule(text: "Fuente: \(source.displayName)", foreground: spec.foreground)

            if !analysis.nonVeganIngredients.isEmpty {
                SummaryBlock(
                    title: "Ingredientes de origen animal:",
                    values: analysis.nonVeganIngredients,
                    foreground: spec.foreground
                )
            }

            if !analysis.doubtfulIngredients.isEmpty {
                SummaryBlock(
                    title: "Ingredientes de procedencia dudosa:",
                    values: analysis.doubtfulIngredients,
                    foreground: spec.foreground
                )
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(spec.background)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: spec.background.opacity(0.24), radius: 12, x: 0, y: 8)
    }

    private var bannerSpec: VeganBannerSpec {
        switch analysis.status {
        case .vegan:
            return VeganBannerSpec(
                headline: "SÍ · PRODUCTO APTO PARA VEGANOS",
                subtitle: "No se han detectado ingredientes de origen animal ni dudoso.",
                background: Color.green,
                foreground: .white,
                symbol: "checkmark.circle.fill"
            )
        case .notVegan:
            return VeganBannerSpec(
                headline: "NO · PRODUCTO NO APTO PARA VEGANOS",
                subtitle: "Open Facts indica ingredientes de origen animal.",
                background: Color(red: 0.76, green: 0.16, blue: 0.16),
                foreground: .white,
                symbol: "xmark.circle.fill"
            )
        case .maybe:
            return VeganBannerSpec(
                headline: "DUDOSO · ORIGEN INCIERTO",
                subtitle: "Open Facts marca ingredientes con origen dudoso.",
                background: Color(red: 0.85, green: 0.56, blue: 0.06),
                foreground: .white,
                symbol: "exclamationmark.triangle.fill"
            )
        case .unknown:
            return VeganBannerSpec(
                headline: "SIN DATOS SUFICIENTES",
                subtitle: "Open Facts no aporta análisis vegano suficiente para este producto.",
                background: Color(red: 0.45, green: 0.47, blue: 0.50),
                foreground: .white,
                symbol: "questionmark.circle.fill"
            )
        }
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
                .font(.title.bold())
                .foregroundStyle(.primary)

            if let brands = product.brands, !brands.isEmpty {
                Text("Marca: \(brands)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            if let quantity = product.quantity, !quantity.isEmpty {
                Text("Cantidad: \(quantity)")
                    .font(.subheadline)
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

    var body: some View {
        SimpleSectionCard(title: "Ingredientes") {
            if let ingredients = product.ingredients, !ingredients.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(ingredients.enumerated()), id: \.offset) { _, ingredient in
                        IngredientRow(ingredient: ingredient)
                    }
                }
            } else {
                Text(product.ingredientsText?.isEmpty == false ? product.ingredientsText! : "—")
            }
        }
    }
}

private struct IngredientRow: View {
    let ingredient: OffIngredient

    var body: some View {
        let kind = IngredientKind(rawValue: ingredient.vegan?.lowercased() ?? "") ?? .unknown
        let spec = kind.spec
        let label = cleanFoodFactsLabel(ingredient.text) ?? "Ingrediente desconocido"

        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(spec.accent)
                .frame(width: 10, height: 10)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 6) {
                Text(label)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                CapsuleChip(text: spec.label, tint: spec.accent)
            }

            Spacer(minLength: 8)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(spec.rowBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct SimpleSectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            content
                .font(.body)
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

private struct SourceCapsule: View {
    let text: String
    let foreground: Color

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
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
            .font(.caption.weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(tint.opacity(0.14))
            .clipShape(Capsule())
    }
}

private struct SummaryBlock: View {
    let title: String
    let values: [String]
    let foreground: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(foreground)
            Text(values.joined(separator: ", "))
                .font(.body)
                .foregroundStyle(foreground)
        }
    }
}

private struct LoadingStateView: View {
    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 16) {
                ProgressView()
                Text("Consultando bases de datos…")
                    .font(.headline)
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
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(.green)

            Text(title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(actionTitle, action: action)
                .buttonStyle(.borderedProminent)
                .tint(.green)
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
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(.red)

            Text(title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(actionTitle, action: action)
                .buttonStyle(.borderedProminent)
                .tint(.green)
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

    var spec: IngredientKindSpec {
        switch self {
        case .vegan:
            return IngredientKindSpec(
                label: "Vegano",
                accent: .green,
                rowBackground: Color.green.opacity(0.10)
            )
        case .animal:
            return IngredientKindSpec(
                label: "Origen animal",
                accent: Color(red: 0.76, green: 0.16, blue: 0.16),
                rowBackground: Color(red: 0.76, green: 0.16, blue: 0.16).opacity(0.10)
            )
        case .doubtful:
            return IngredientKindSpec(
                label: "Dudoso",
                accent: Color(red: 0.85, green: 0.56, blue: 0.06),
                rowBackground: Color(red: 0.85, green: 0.56, blue: 0.06).opacity(0.10)
            )
        case .unknown:
            return IngredientKindSpec(
                label: "Sin dato",
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
    let nutriments: Nutriments?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NutritionRow(label: "Energía", value: format(nutriments?.energyKcal100g, unit: "kcal"))
            NutritionRow(label: "Grasas", value: format(nutriments?.fat100g, unit: "g"))
            NutritionRow(label: "Grasas saturadas", value: format(nutriments?.saturatedFat100g, unit: "g"))
            NutritionRow(label: "Azúcares", value: format(nutriments?.sugars100g, unit: "g"))
            NutritionRow(label: "Sal", value: format(nutriments?.salt100g, unit: "g"))
            NutritionRow(label: "Proteínas", value: format(nutriments?.proteins100g, unit: "g"))
        }
    }

    private func format(_ value: Double?, unit: String) -> String {
        guard let value else { return "—" }
        if value.rounded() == value {
            return "\(Int(value)) \(unit)"
        }
        return String(format: "%.1f %@", value, unit)
    }
}

private struct NutritionRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
