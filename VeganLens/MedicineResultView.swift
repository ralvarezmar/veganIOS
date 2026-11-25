import SwiftData
import SwiftUI
import UIKit

let medicineBlue = Color(red: 0x15 / 255, green: 0x65 / 255, blue: 0xC0 / 255)
private let medicineBlueLight = Color(red: 0xE3 / 255, green: 0xF2 / 255, blue: 0xFD / 255)

/// Sends medicine barcodes to `MedicineResultView` and everything else to the food result.
struct ScanResultRouter<FoodContent: View>: View {
    let barcode: String
    @ViewBuilder let food: () -> FoodContent
    @State private var searchAsProduct: Bool

    init(barcode: String, @ViewBuilder food: @escaping () -> FoodContent) {
        self.barcode = barcode
        self.food = food
        _searchAsProduct = State(initialValue: !isMedicineBarcode(barcode))
    }

    var body: some View {
        if searchAsProduct {
            food()
        } else {
            MedicineResultView(barcode: barcode, onSearchAsProduct: { searchAsProduct = true })
        }
    }
}

private enum MedicineLoadState {
    case loading
    case success(MedicineInfo, fromCache: Bool)
    case notFound([MedicineSource])
    case error(String)
}

struct MedicineResultView: View {
    let barcode: String
    let onSearchAsProduct: () -> Void

    @Environment(\.modelContext) private var modelContext
    @AppStorage(AllergenPreferences.selectedKeysKey) private var selectedAllergenStorage = ""
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafe = false
    @State private var state: MedicineLoadState = .loading
    @State private var showingShareSheet = false
    @State private var shareText: String?
    @State private var shareImage: UIImage?

    private let service = MedicineService()

    var body: some View {
        content
            .navigationTitle(L("medicine_badge"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if case .success(let medicine, _) = state {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            prepareShare(medicine)
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .accessibilityIdentifier("medicine_share_button")
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: [shareText as Any?, shareImage as Any?].compactMap { $0 })
            }
            .task(id: barcode) { await load() }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .loading:
            VStack(spacing: 16) {
                ProgressView().tint(medicineBlue)
                Text(L("medicine_loading")).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .notFound(let sources):
            messageView(
                title: L("medicine_not_found_title"),
                message: LF("medicine_not_found_message", sources.map(\.displayName).joined(separator: ", "))
            )
        case .error:
            messageView(title: L("medicine_not_found_title"), message: L("medicine_offline_error"))
        case .success(let medicine, let fromCache):
            MedicineDetailsView(
                medicine: medicine,
                analysis: analyzeMedicine(medicine),
                fromCache: fromCache,
                selectedAllergenKeys: AllergenPreferences.decodeSelectedKeys(selectedAllergenStorage),
                colorblindSafe: colorblindSafe
            )
        }
    }

    private func messageView(title: String, message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "cross.case")
                .font(.system(size: 48))
                .foregroundStyle(medicineBlue)
            Text(title).font(.title3.bold())
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            if isMedicineSearchCode(barcode) {
                Button(L("retry")) { Task { await load() } }
                    .buttonStyle(.borderedProminent)
                    .tint(medicineBlue)
            } else {
                Button(L("medicine_search_as_product"), action: onSearchAsProduct)
                    .buttonStyle(.borderedProminent)
                    .tint(medicineBlue)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @MainActor
    private func load() async {
        state = .loading
        let result = await service.fetchMedicine(barcode: barcode)
        guard !Task.isCancelled else { return }
        switch result {
        case .success(let medicine, let fromCache):
            upsertScanRecord(
                barcode: barcode,
                productName: medicine.name,
                brand: medicine.laboratory,
                imageURL: medicine.imageURL,
                verdict: analyzeMedicine(medicine).veganStatus,
                category: .medicine,
                in: modelContext
            )
            state = .success(medicine, fromCache: fromCache)
        case .notFound(let sources):
            state = .notFound(sources)
        case .error(let message):
            state = .error(message)
        }
    }

    @MainActor
    private func prepareShare(_ medicine: MedicineInfo) {
        let analysis = analyzeMedicine(medicine)
        shareText = String(format: L("share_result_template"), medicine.name, shareVerdictLabel(for: analysis.veganStatus))
        let content = MedicineShareCardContent(medicine: medicine, analysis: analysis, colorblindSafe: colorblindSafe)
        Task { @MainActor in
            var loaded = content
            loaded.productImage = await loadShareProductImage(from: medicine.imageURL)
            shareImage = renderMedicineShareCard(loaded)
            showingShareSheet = true
        }
    }
}

func medicineVerdictText(_ status: VeganStatus) -> String {
    switch status {
    case .vegan: return L("medicine_verdict_vegan")
    case .notVegan: return L("medicine_verdict_not_vegan")
    case .maybe: return L("medicine_verdict_maybe")
    case .unknown: return L("medicine_verdict_unknown")
    }
}

/// Only the excipients behind a not-vegan or doubtful verdict, so the share card stays short.
func medicineShareCauses(_ analysis: MedicineAnalysis) -> [String] {
    switch analysis.veganStatus {
    case .notVegan where !analysis.animalItems.isEmpty:
        return [LF("medicine_animal_items", analysis.animalItems.joined(separator: ", "))]
    case .maybe where !analysis.doubtfulItems.isEmpty:
        return [LF("medicine_doubtful_items", analysis.doubtfulItems.joined(separator: ", "))]
    default:
        return []
    }
}

func medicineDietNotes(_ analysis: MedicineAnalysis, selectedAllergenKeys: Set<String> = []) -> [String] {
    var notes: [String] = []
    if !analysis.animalItems.isEmpty {
        notes.append(LF("medicine_animal_items", analysis.animalItems.joined(separator: ", ")))
    }
    if !analysis.doubtfulItems.isEmpty {
        notes.append(LF("medicine_doubtful_items", analysis.doubtfulItems.joined(separator: ", ")))
    }
    switch analysis.glutenStatus {
    case .contains: notes.append(LF("medicine_gluten_contains", analysis.glutenItems.joined(separator: ", ")))
    case .notDeclared: notes.append(L("medicine_gluten_not_declared"))
    case .unknown: notes.append(L("medicine_gluten_unknown"))
    }
    if let milk = analysis.allergenItems["milk"] {
        notes.append(LF("medicine_lactose_contains", milk.joined(separator: ", ")))
    } else if analysis.hasExcipientData {
        notes.append(L("medicine_lactose_free"))
    }
    for option in AllergenCatalog.selectedOptions(selectedAllergenKeys) {
        guard let items = analysis.allergenItems[option.key] else { continue }
        notes.append(LF("medicine_profile_alert", L(option.labelKey), items.joined(separator: ", ")))
    }
    return notes
}

private struct MedicineDetailsView: View {
    let medicine: MedicineInfo
    let analysis: MedicineAnalysis
    let fromCache: Bool
    let selectedAllergenKeys: Set<String>
    let colorblindSafe: Bool

    @Environment(\.openURL) private var openURL

    private var verdictColor: Color {
        veganVerdictColor(for: analysis.veganStatus, colorblindSafe: colorblindSafe)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                verdictCard
                dietCard
                excipientsCard
                disclaimer
                if let leaflet = medicine.leafletURL, let url = URL(string: leaflet) {
                    Button {
                        openURL(url)
                    } label: {
                        Label(L("medicine_open_leaflet"), systemImage: "doc.text")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(medicineBlue)
                }
            }
            .padding()
        }
        .background(medicineBlueLight.opacity(0.35))
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Label(L("medicine_badge"), systemImage: "cross.case.fill")
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.white.opacity(0.2)))
                Text(medicine.name)
                    .font(.title2.bold())
                    .accessibilityIdentifier("medicine_name")
                infoRow(L("medicine_active_ingredients"), medicine.activeIngredients.joined(separator: ", "))
                infoRow(L("medicine_dose"), medicine.dose)
                infoRow(L("medicine_form"), medicine.pharmaceuticalForm)
                infoRow(L("medicine_laboratory"), medicine.laboratory)
                if medicine.prescriptionRequired == true {
                    Text(L("medicine_prescription"))
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(.white))
                        .foregroundStyle(medicineBlue)
                }
                Text(LF("medicine_source", medicine.source.displayName) + (fromCache ? " · \(L("medicine_from_cache"))" : ""))
                    .font(.caption)
                    .opacity(0.85)
            }
            Spacer(minLength: 0)
            Image("medicine_pill")
                .resizable()
                .scaledToFit()
                .frame(width: 84, height: 84)
                .accessibilityLabel(L("medicine_mascot_description"))
        }
        .foregroundStyle(.white)
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(colors: [medicineBlue, medicineBlue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
    }

    @ViewBuilder
    private func infoRow(_ label: String, _ value: String?) -> some View {
        if let value, !value.isEmpty {
            Text("\(label): ").font(.subheadline.bold()) + Text(value).font(.subheadline)
        }
    }

    private var verdictCard: some View {
        HStack(spacing: 12) {
            Image(systemName: verdictShareSymbolName(for: analysis.veganStatus))
                .font(.title2.bold())
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(Circle().fill(verdictColor))
            Text(medicineVerdictText(analysis.veganStatus))
                .font(.headline)
                .accessibilityIdentifier("medicine_verdict")
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(verdictColor, lineWidth: 2))
    }

    private var dietCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(medicineDietNotes(analysis, selectedAllergenKeys: selectedAllergenKeys), id: \.self) { note in
                Label(note, systemImage: "exclamationmark.circle")
                    .font(.subheadline)
            }
            if analysis.glutenStatus == .contains {
                Text(L("medicine_gluten_note"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
    }

    private var excipientsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L("medicine_excipients")).font(.headline)
            if medicine.excipients.isEmpty {
                Text(L("medicine_no_excipients")).font(.subheadline).foregroundStyle(.secondary)
            } else {
                let flagged = analysis.flaggedItems
                VerdictShareChipsLayout {
                    ForEach(medicine.excipients, id: \.self) { excipient in
                        let isFlagged = flagged.contains(excipient)
                        Text(excipient)
                            .font(.caption.weight(isFlagged ? .bold : .regular))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .foregroundStyle(isFlagged ? .white : medicineBlue)
                            .background(Capsule().fill(isFlagged ? verdictColor : medicineBlueLight))
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
    }

    private var disclaimer: some View {
        Label(L("medicine_disclaimer"), systemImage: "info.circle")
            .font(.footnote)
            .foregroundStyle(medicineBlue)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 14).fill(medicineBlueLight))
    }
}

// MARK: - Share card

struct MedicineShareCardContent {
    let title: String
    let laboratory: String?
    let headline: String
    let chips: [String]
    let notes: [String]
    let status: VeganStatus
    let colorblindSafe: Bool
    var productImage: UIImage? = nil

    init(medicine: MedicineInfo, analysis: MedicineAnalysis, colorblindSafe: Bool) {
        title = medicine.name
        laboratory = medicine.laboratory
        headline = medicineVerdictText(analysis.veganStatus)
        chips = []
        notes = medicineShareCauses(analysis)
        status = analysis.veganStatus
        self.colorblindSafe = colorblindSafe
    }
}

private struct MedicalCross: Shape {
    func path(in rect: CGRect) -> Path {
        let third = min(rect.width, rect.height) / 3
        var path = Path()
        path.addRect(CGRect(x: rect.midX - third / 2, y: rect.minY, width: third, height: rect.height))
        path.addRect(CGRect(x: rect.minX, y: rect.midY - third / 2, width: rect.width, height: third))
        return path
    }
}

/// Medicine counterpart of `VerdictShareCardView`: blue medical styling and the pill mascot,
/// which never appears on food cards.
struct MedicineShareCardView: View {
    let content: MedicineShareCardContent

    private var accent: Color {
        veganVerdictColor(for: content.status, colorblindSafe: content.colorblindSafe)
    }

    var body: some View {
        ZStack(alignment: .top) {
            medicineBlue
            MedicalCross().fill(Color.white.opacity(0.12)).frame(width: 130, height: 130).offset(x: 215, y: 90)
            MedicalCross().fill(Color.white.opacity(0.12)).frame(width: 90, height: 90).offset(x: -230, y: 230)

            VStack(spacing: 0) {
                HStack {
                    Text("VeganLens")
                        .font(.system(size: 22, weight: .bold))
                    Spacer()
                    Label(L("medicine_badge").uppercased(), systemImage: "cross.case.fill")
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundStyle(medicineBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(.white))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 36)
                .padding(.top, 30)

                HStack(spacing: 14) {
                    ZStack {
                        Circle().fill(.white)
                        Image(systemName: verdictShareSymbolName(for: content.status))
                            .font(.system(size: 34, weight: .heavy))
                            .foregroundStyle(accent)
                    }
                    .frame(width: 66, height: 66)
                    Text(content.headline)
                        .font(.system(size: 23, weight: .heavy))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 36)
                .padding(.top, 20)
                .frame(height: 100)

                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 28, style: .continuous).fill(.white)
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle().fill(medicineBlue).frame(height: 6).padding(.horizontal, -32).padding(.top, -32)
                        HStack(alignment: .top, spacing: 14) {
                            if let image = content.productImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .background(Color(white: 0.95))
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text(content.title)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(Color(white: 0.12))
                                    .lineLimit(3)
                                if let laboratory = content.laboratory {
                                    Text(laboratory)
                                        .font(.system(size: 17))
                                        .foregroundStyle(Color(white: 0.42))
                                        .lineLimit(2)
                                }
                                if !content.chips.isEmpty {
                                    VerdictShareChipsLayout {
                                        ForEach(content.chips, id: \.self) { chip in
                                            Text(chip)
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundStyle(medicineBlue)
                                                .lineLimit(1)
                                                .padding(.horizontal, 11)
                                                .padding(.vertical, 5)
                                                .background(Capsule().fill(medicineBlueLight))
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(content.notes, id: \.self) { note in
                                HStack(alignment: .firstTextBaseline, spacing: 8) {
                                    MedicalCross().fill(medicineBlue).frame(width: 9, height: 9)
                                    Text(note)
                                        .font(.system(size: 16))
                                        .foregroundStyle(Color(white: 0.25))
                                        .lineLimit(2)
                                }
                            }
                        }
                        .padding(.trailing, 80)
                        .padding(.top, 6)
                        .layoutPriority(-1)
                        Spacer(minLength: 0)
                        Text(L("medicine_disclaimer_short"))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(medicineBlue)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 12).fill(medicineBlueLight))
                            .padding(.trailing, 80)
                        Text(L("share_card_tagline"))
                            .font(.system(size: 15))
                            .foregroundStyle(Color(white: 0.42))
                            .lineLimit(2)
                            .padding(.trailing, 80)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(32)
                    Image("medicine_pill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 92, height: 92)
                        .padding(.trailing, 12)
                        .padding(.bottom, 8)
                }
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
            }
        }
        .frame(width: 540, height: 675)
        .clipped()
        .environment(\.colorScheme, .light)
    }
}

@MainActor
func renderMedicineShareCard(_ content: MedicineShareCardContent) -> UIImage? {
    let renderer = ImageRenderer(content: MedicineShareCardView(content: content))
    renderer.scale = 2
    return renderer.uiImage
}
