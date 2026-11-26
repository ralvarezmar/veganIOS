import Foundation

enum MedicineSource: String, Codable, CaseIterable {
    case cima = "CIMA"
    case openFDA = "OPEN_FDA"

    var displayName: String {
        switch self {
        case .cima: return "CIMA (AEMPS)"
        case .openFDA: return "openFDA"
        }
    }

    var countryCode: String {
        switch self {
        case .cima: return "ES"
        case .openFDA: return "US"
        }
    }

    var qualifiedName: String { "\(displayName) · \(countryCode)" }
}

struct MedicineInfo: Codable, Equatable {
    let code: String
    let source: MedicineSource
    let name: String
    let activeIngredients: [String]
    let excipients: [String]
    var laboratory: String? = nil
    var dose: String? = nil
    var pharmaceuticalForm: String? = nil
    var imageURL: String? = nil
    var leafletURL: String? = nil
    var prescriptionRequired: Bool? = nil
    var extraText: String? = nil
}

enum MedicineCode: Equatable {
    /// Spanish "código nacional" (6 digits, without its control digit) encoded in an 847000 EAN-13.
    case spanishNational(String)
    /// US UPC-A with number system 3, whose 10 middle digits are the NDC.
    case usNDC(upc: String, ndcCandidates: [String])
    /// CIMA registration number, used for medicines picked from a name search.
    case cimaRegistration(String)
    /// openFDA label set id, used for medicines picked from a name search.
    case openFDASetId(String)
}

let cimaRegistrationPrefix = "cima-"
let openFDASetIdPrefix = "fda-"

func cimaRegistrationCode(_ nregistro: String) -> String { cimaRegistrationPrefix + nregistro }
func openFDASetIdCode(_ setId: String) -> String { openFDASetIdPrefix + setId }

/// True for codes that come from a medicine name search rather than a printed barcode.
func isMedicineSearchCode(_ code: String) -> Bool {
    switch medicineCode(for: code) {
    case .cimaRegistration, .openFDASetId: return true
    default: return false
    }
}

private func searchCodeID(_ code: String, prefix: String) -> String? {
    guard code.hasPrefix(prefix) else { return nil }
    let id = String(code.dropFirst(prefix.count))
    guard !id.isEmpty, id.allSatisfy({ $0.isASCII && ($0.isLetter || $0.isNumber || $0 == "-") }) else { return nil }
    return id
}

private let spanishMedicinePrefix = "847000"

func medicineCode(for rawBarcode: String) -> MedicineCode? {
    let digits = rawBarcode.trimmingCharacters(in: .whitespacesAndNewlines)
    if let id = searchCodeID(digits, prefix: cimaRegistrationPrefix) { return .cimaRegistration(id) }
    if let id = searchCodeID(digits, prefix: openFDASetIdPrefix) { return .openFDASetId(id) }
    if digits.hasPrefix(cimaRegistrationPrefix) || digits.hasPrefix(openFDASetIdPrefix) { return nil }
    guard !digits.isEmpty, digits.allSatisfy(\.isASCIIDigit) else { return nil }

    let ean13: String?
    switch digits.count {
    case 14: ean13 = digits.hasPrefix("0") ? String(digits.dropFirst()) : nil
    case 13: ean13 = digits
    default: ean13 = nil
    }
    if let ean13, ean13.hasPrefix(spanishMedicinePrefix) {
        return .spanishNational(String(ean13.dropFirst(6).prefix(6)))
    }

    let upc: String?
    switch digits.count {
    case 12: upc = digits
    case 13: upc = digits.hasPrefix("0") ? String(digits.dropFirst()) : nil
    case 14: upc = digits.hasPrefix("00") ? String(digits.dropFirst(2)) : nil
    default: upc = nil
    }
    guard let upc, upc.hasPrefix("3") else { return nil }
    let ndc = String(upc.dropFirst().prefix(10))
    return .usNDC(upc: upc, ndcCandidates: ndcCandidates(ndc))
}

/// A 10-digit NDC is written as 4-4-2, 5-3-2 or 5-4-1; the barcode does not say which.
func ndcCandidates(_ ndc: String) -> [String] {
    let c = Array(ndc)
    func part(_ from: Int, _ to: Int) -> String { String(c[from..<to]) }
    return [
        "\(part(0, 4))-\(part(4, 8))-\(part(8, 10))",
        "\(part(0, 5))-\(part(5, 8))-\(part(8, 10))",
        "\(part(0, 5))-\(part(5, 9))-\(part(9, 10))",
    ]
}

func isMedicineBarcode(_ rawBarcode: String) -> Bool {
    medicineCode(for: rawBarcode) != nil
}

private let gs1GroupSeparator: Character = "\u{1D}"
private let gs1SymbologyIdentifiers = ["]d2", "]C1", "]Q3"]
private let gs1FixedLengthAIs = ["01": 14, "11": 6, "15": 6, "16": 6, "17": 6]
private let gs1VariableLengthAIs: Set<String> = ["10", "21"]

/// Extracts the GTIN (AI 01) from a GS1 DataMatrix, like the one on Spanish prescription medicine
/// packs (PC 0847000 + national code), and returns it in the form a linear barcode would have.
func gtinFromGS1DataMatrix(_ rawValue: String) -> String? {
    var data = Array(rawValue.trimmingCharacters(in: .whitespacesAndNewlines))
    if let identifier = gs1SymbologyIdentifiers.first(where: { data.starts(with: $0) }) {
        data.removeFirst(identifier.count)
    }
    var index = 0
    while index < data.count {
        if data[index] == gs1GroupSeparator {
            index += 1
            continue
        }
        let ai = String(data[index..<min(index + 2, data.count)])
        if ai == "01" {
            let gtin = String(data[(index + 2)...].prefix(14))
            guard gtin.count == 14, gtin.allSatisfy(\.isASCIIDigit) else { return nil }
            return gtin.hasPrefix("0") ? String(gtin.dropFirst()) : gtin
        } else if let length = gs1FixedLengthAIs[ai] {
            index += 2 + length
        } else if gs1VariableLengthAIs.contains(ai) {
            guard let end = data[(index + 2)...].firstIndex(of: gs1GroupSeparator) else { return nil }
            index = end + 1
        } else {
            return nil
        }
    }
    return nil
}

private extension Character {
    var isASCIIDigit: Bool { ("0"..."9").contains(self) }
}

// MARK: - CIMA (AEMPS)

struct CimaMedicamento: Decodable {
    var nregistro: String?
    var nombre: String?
    var pactivos: String?
    var labtitular: String?
    var receta: Bool?
    var dosis: String?
    var formaFarmaceutica: CimaItem?
    var principiosActivos: [CimaSustancia]?
    var excipientes: [CimaSustancia]?
    var fotos: [CimaFoto]?
    var docs: [CimaDocumento]?
}

struct CimaSearchResponse: Decodable {
    var totalFilas: Int?
    var resultados: [CimaMedicamento]?
}

/// A medicine found by name; `code` opens it in the medicine result screen.
struct MedicineSearchItem: Equatable, Identifiable {
    var code: String
    var name: String
    var laboratory: String?
    var imageURL: String?
    var source: MedicineSource

    var id: String { code }
}

struct CimaItem: Decodable {
    var nombre: String?
}

struct CimaSustancia: Decodable {
    var nombre: String?
    var orden: Int?
}

struct CimaFoto: Decodable {
    var tipo: String?
    var url: String?
}

struct CimaDocumento: Decodable {
    var tipo: Int?
    var url: String?
    var urlHtml: String?
}

private let cimaLeafletDocType = 2

private func nonBlank(_ value: String?) -> String? {
    guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmed.isEmpty else { return nil }
    return trimmed
}

private func uniqued(_ values: [String]) -> [String] {
    var seen = Set<String>()
    return values.filter { seen.insert($0).inserted }
}

extension CimaMedicamento {
    func toMedicineInfo(code: String) -> MedicineInfo? {
        guard let name = nonBlank(nombre) else { return nil }
        var actives = (principiosActivos ?? []).compactMap { nonBlank($0.nombre) }
        if actives.isEmpty {
            actives = (pactivos ?? "").split(separator: ",").compactMap { nonBlank(String($0)) }
        }
        let leaflet = (docs ?? []).first { $0.tipo == cimaLeafletDocType }
        let photos = fotos ?? []
        return MedicineInfo(
            code: code,
            source: .cima,
            name: name,
            activeIngredients: actives,
            excipients: uniqued(
                (excipientes ?? [])
                    .sorted { ($0.orden ?? Int.max) < ($1.orden ?? Int.max) }
                    .compactMap { nonBlank($0.nombre) }
            ),
            laboratory: nonBlank(labtitular),
            dose: nonBlank(dosis),
            pharmaceuticalForm: nonBlank(formaFarmaceutica?.nombre),
            imageURL: photos.first { $0.tipo == "materialas" }?.url ?? photos.first?.url,
            leafletURL: nonBlankLeaflet(leaflet?.urlHtml) ?? nonBlankLeaflet(leaflet?.url),
            prescriptionRequired: receta
        )
    }
}

// MARK: - openFDA

struct OpenFDALabelResponse: Decodable {
    var results: [OpenFDALabel]?
}

struct OpenFDALabel: Decodable {
    var setId: String?
    var inactiveIngredient: [String]?
    var activeIngredient: [String]?
    var splProductDataElements: [String]?
    var description: [String]?
    var openfda: OpenFDAFields?

    enum CodingKeys: String, CodingKey {
        case setId = "set_id"
        case inactiveIngredient = "inactive_ingredient"
        case activeIngredient = "active_ingredient"
        case splProductDataElements = "spl_product_data_elements"
        case description
        case openfda
    }
}

struct OpenFDAFields: Decodable {
    var brandName: [String]?
    var genericName: [String]?
    var manufacturerName: [String]?
    var substanceName: [String]?
    var productType: [String]?
    var dosageForm: [String]?

    enum CodingKeys: String, CodingKey {
        case brandName = "brand_name"
        case genericName = "generic_name"
        case manufacturerName = "manufacturer_name"
        case substanceName = "substance_name"
        case productType = "product_type"
        case dosageForm = "dosage_form"
    }
}

func splitIngredientList(_ text: String) -> [String] {
    let withoutPrefix = text.replacingOccurrences(
        of: #"^\s*(inactive ingredients?|other ingredients?)\s*[:.]?\s*"#,
        with: "",
        options: [.regularExpression, .caseInsensitive]
    )
    let parts = withoutPrefix
        .components(separatedBy: CharacterSet(charactersIn: ",;•\n"))
        .map { part -> String in
            var item = part.trimmingCharacters(in: .whitespacesAndNewlines)
            while item.hasSuffix(".") { item.removeLast() }
            return item.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        .filter { !$0.isEmpty }
    return uniqued(parts)
}

extension CimaMedicamento {
    func toSearchItem() -> MedicineSearchItem? {
        guard let id = nonBlank(nregistro), let name = nonBlank(nombre) else { return nil }
        let photos = fotos ?? []
        return MedicineSearchItem(
            code: cimaRegistrationCode(id),
            name: name,
            laboratory: nonBlank(labtitular),
            imageURL: (photos.first { $0.tipo == "materialas" } ?? photos.first)?.url,
            source: .cima
        )
    }
}

extension OpenFDALabel {
    func toSearchItem() -> MedicineSearchItem? {
        guard let id = nonBlank(setId), let info = toMedicineInfo(code: openFDASetIdCode(id)) else { return nil }
        return MedicineSearchItem(code: info.code, name: info.name, laboratory: info.laboratory, imageURL: nil, source: .openFDA)
    }

    func toMedicineInfo(code: String) -> MedicineInfo? {
        let fields = openfda
        guard let name = nonBlank(fields?.brandName?.first) ?? nonBlank(fields?.genericName?.first) else { return nil }
        let substances = fields?.substanceName ?? []
        let actives = uniqued((substances.isEmpty ? (fields?.genericName ?? []) : substances).compactMap(nonBlank))
        let extra = ((splProductDataElements ?? []) + (description ?? [])).joined(separator: " ")
        return MedicineInfo(
            code: code,
            source: .openFDA,
            name: name,
            activeIngredients: actives,
            excipients: uniqued((inactiveIngredient ?? []).flatMap(splitIngredientList)),
            laboratory: nonBlank(fields?.manufacturerName?.first),
            pharmaceuticalForm: nonBlank(fields?.dosageForm?.first),
            leafletURL: nonBlankLeaflet(setId).map { "https://dailymed.nlm.nih.gov/dailymed/lookup.cfm?setid=\($0)" },
            prescriptionRequired: fields?.productType?.first.map { $0.localizedCaseInsensitiveContains("PRESCRIPTION") },
            extraText: nonBlank(extra)
        )
    }
}

private func nonBlankLeaflet(_ value: String?) -> String? {
    guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmed.isEmpty else { return nil }
    return trimmed
}
