import Foundation
import SwiftUI
import SwiftData
import AVFoundation
import UIKit

struct ScannerView: View {
    @Binding var isScannerRunning: Bool
    let onDetectedBarcode: (String) -> Void

    @Environment(\.scenePhase) private var scenePhase
    @State private var authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    @State private var isRequestingAccess = false

    var body: some View {
        ZStack {
            if authorizationStatus == .authorized {
                BarcodeScannerView(isRunning: $isScannerRunning) { barcode in
                    isScannerRunning = false
                    onDetectedBarcode(barcode)
                }
                .ignoresSafeArea()

                ScannerOverlayView()
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
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                updateAuthorizationState()
            }
        }
        .onChange(of: authorizationStatus) { _, newValue in
            isScannerRunning = newValue == .authorized
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
    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 8) {
                Text("Apunta la cámara al código de barras del producto.")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Se admiten códigos EAN y UPC.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(.black.opacity(0.45))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .padding()
        }
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

            Image(systemName: "camera.fill")
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.20))

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
                .tint(Color(red: 0.18, green: 0.49, blue: 0.20))
                .disabled(isRequestingAccess)
            } else {
                Button {
                    onOpenSettings()
                } label: {
                    Label("Abrir ajustes", systemImage: "gearshape")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.18, green: 0.49, blue: 0.20))
            }

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
        switch loadState {
        case .loading:
            ProgressView("Cargando producto…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .notFound(let consultedSources):
            ErrorStateView(
                title: consultedSourcesMessage(consultedSources),
                message: "Prueba a reintentar o vuelve al escáner.",
                retryTitle: "Reintentar",
                onRetry: { retrySeed = UUID() },
                onBack: onBack
            )
        case .networkError(let message):
            ErrorStateView(
                title: message,
                message: "Revisa tu conexión e inténtalo de nuevo.",
                retryTitle: "Reintentar",
                onRetry: { retrySeed = UUID() },
                onBack: onBack
            )
        case .success(let product, let source):
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VeganBannerView(analysis: analyzeVegan(product))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(displayName(for: product))
                            .font(.title.bold())
                        if let brands = product.brands, !brands.isEmpty {
                            Text("Marca: \(brands)")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                        Text("Fuente: \(source.displayName)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    if let imageURLString = product.imageUrl, let url = URL(string: imageURLString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 220)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            case .failure:
                                EmptyView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }

                    SectionBlock(title: "Ingredientes") {
                        Text(product.ingredientsText?.isEmpty == false ? product.ingredientsText! : "—")
                    }

                    SectionBlock(title: "Aditivos") {
                        Text(cleanTags(product.additivesTags))
                    }

                    SectionBlock(title: "Alérgenos") {
                        Text(cleanTags(product.allergensTags))
                    }

                    SectionBlock(title: "Nutrición básica por 100 g") {
                        NutritionGrid(nutriments: product.nutriments)
                    }

                    if let grade = product.nutriscoreGrade, !grade.isEmpty {
                        SectionBlock(title: "Nutri-Score") {
                            Text(grade.uppercased())
                                .font(.headline.bold())
                        }
                    }
                }
                .padding()
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

    private func displayName(for product: Product) -> String {
        let trimmed = product.productName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? barcode : trimmed
    }

    private func consultedSourcesMessage(_ consultedSources: [ProductSource]) -> String {
        var seen = Set<String>()
        let names = consultedSources
            .map(\.displayName)
            .filter { seen.insert($0).inserted }
        guard !names.isEmpty else {
            return "Producto no encontrado en Open Food Facts"
        }
        return "No se ha encontrado información suficiente en ninguna de las bases consultadas: \(names.joined(separator: \", \"))."
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
        List {
            if records.isEmpty {
                ContentUnavailableView("No hay escaneos recientes.", systemImage: "clock.arrow.circlepath")
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
        HStack(spacing: 12) {
            if let imageURLString = record.imageURL, let url = URL(string: imageURLString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 56, height: 56)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    case .failure:
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 56, height: 56)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(record.productName?.isEmpty == false ? record.productName! : record.barcode)
                    .font(.headline)
                if let brand = record.brand, !brand.isEmpty {
                    Text(brand)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text(record.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

private struct VeganBannerView: View {
    let analysis: VeganAnalysis

    var body: some View {
        let spec = bannerSpec
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: spec.symbol)
                    .font(.system(size: 28, weight: .semibold))
                Text(spec.headline)
                    .font(.title2.bold())
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
            }

            Text(spec.subtitle)
                .font(.subheadline)
                .opacity(0.95)

            if !analysis.nonVeganIngredients.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ingredientes de origen animal:")
                        .font(.caption.bold())
                    Text(analysis.nonVeganIngredients.joined(separator: ", "))
                        .font(.body)
                }
            }

            if !analysis.doubtfulIngredients.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ingredientes de procedencia dudosa:")
                        .font(.caption.bold())
                    Text(analysis.doubtfulIngredients.joined(separator: ", "))
                        .font(.body)
                }
            }
        }
        .foregroundStyle(spec.foreground)
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(spec.background)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: spec.background.opacity(0.28), radius: 10, x: 0, y: 6)
    }

    private var bannerSpec: VeganBannerSpec {
        switch analysis.status {
        case .vegan:
            return VeganBannerSpec(
                headline: "SÍ · PRODUCTO APTO PARA VEGANOS",
                subtitle: "No se han detectado ingredientes de origen animal ni dudoso.",
                background: Color(red: 0.18, green: 0.49, blue: 0.20),
                foreground: .white,
                symbol: "checkmark.circle.fill"
            )
        case .notVegan:
            return VeganBannerSpec(
                headline: "NO · PRODUCTO NO APTO PARA VEGANOS",
                subtitle: "Open Food Facts indica ingredientes de origen animal.",
                background: Color(red: 0.76, green: 0.16, blue: 0.16),
                foreground: .white,
                symbol: "xmark.circle.fill"
            )
        case .maybe:
            return VeganBannerSpec(
                headline: "DUDOSO · ORIGEN INCIERTO",
                subtitle: "Open Food Facts marca ingredientes con origen dudoso.",
                background: Color(red: 0.85, green: 0.56, blue: 0.06),
                foreground: .white,
                symbol: "exclamationmark.triangle.fill"
            )
        case .unknown:
            return VeganBannerSpec(
                headline: "SIN DATOS SUFICIENTES",
                subtitle: "Open Food Facts no aporta análisis vegano suficiente para este producto.",
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

private struct SectionBlock<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
                .font(.body)
                .foregroundStyle(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
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

private struct ErrorStateView: View {
    let title: String
    let message: String
    let retryTitle: String
    let onRetry: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Spacer()
            Text(title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(retryTitle, action: onRetry)
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.18, green: 0.49, blue: 0.20))
            Button("Volver", action: onBack)
                .buttonStyle(.bordered)
            Spacer()
        }
        .padding()
    }
}
