import Foundation
import XCTest
@testable import VeganLens

final class MedicineBarcodeTests: XCTestCase {
    func testSpanishNationalCodeIsExtracted() {
        XCTAssertEqual(medicineCode(for: "8470007127295"), .spanishNational("712729"))
        XCTAssertEqual(medicineCode(for: "08470007127295"), .spanishNational("712729"))
    }

    func testUSUPCProducesNDCCandidates() {
        let expected = MedicineCode.usNDC(
            upc: "312345678906",
            ndcCandidates: ["1234-5678-90", "12345-678-90", "12345-6789-0"]
        )
        XCTAssertEqual(medicineCode(for: "312345678906"), expected)
        XCTAssertEqual(medicineCode(for: "0312345678906"), expected)
    }

    func testSearchCodesAreMedicineCodes() {
        XCTAssertEqual(medicineCode(for: cimaRegistrationCode("64101")), .cimaRegistration("64101"))
        XCTAssertEqual(medicineCode(for: openFDASetIdCode("ab-12")), .openFDASetId("ab-12"))
        XCTAssertTrue(isMedicineBarcode("cima-64101"))
        XCTAssertTrue(isMedicineSearchCode("fda-ab-12"))
        XCTAssertFalse(isMedicineSearchCode("8470007127295"))
        XCTAssertNil(medicineCode(for: "cima-"))
        XCTAssertNil(medicineCode(for: "fda-a/b"))
    }

    func testFoodAndInvalidBarcodesAreNotMedicines() {
        XCTAssertFalse(isMedicineBarcode("8410000810004"))
        XCTAssertFalse(isMedicineBarcode("012345678905"))
        XCTAssertFalse(isMedicineBarcode("84700A7127295"))
        XCTAssertFalse(isMedicineBarcode(""))
    }

    func testSpanishMedicineDataMatrixYieldsNationalCode() {
        let gtin = gtinFromGS1DataMatrix("010847000712729521ABC123XYZ\u{1D}1724123110LOT42")
        XCTAssertEqual(gtin, "8470007127295")
        XCTAssertEqual(gtin.flatMap { medicineCode(for: $0) }, .spanishNational("712729"))
    }

    func testDataMatrixGTINIsFoundAfterOtherAIs() {
        XCTAssertEqual(gtinFromGS1DataMatrix("]d2172412311012345\u{1D}0108470007127295"), "8470007127295")
        XCTAssertEqual(gtinFromGS1DataMatrix("\u{1D}21SERIAL\u{1D}0108470007127295"), "8470007127295")
    }

    func testNonGS1DataMatrixIsIgnored() {
        XCTAssertNil(gtinFromGS1DataMatrix("https://example.com"))
        XCTAssertNil(gtinFromGS1DataMatrix("0108470007"))
        XCTAssertNil(gtinFromGS1DataMatrix("21SERIALWITHOUTGTIN"))
        XCTAssertNil(gtinFromGS1DataMatrix(""))
    }
}

final class MedicineAnalyzerTests: XCTestCase {
    private func medicine(excipients: [String], extraText: String? = nil) -> MedicineInfo {
        MedicineInfo(code: "1", source: .cima, name: "Test", activeIngredients: [], excipients: excipients, extraText: extraText)
    }

    func testGelatinAndLactoseAreAnimal() {
        let analysis = analyzeMedicine(medicine(excipients: ["LACTOSA MONOHIDRATO", "GELATINA", "TALCO"]))
        XCTAssertEqual(analysis.veganStatus, .notVegan)
        XCTAssertEqual(analysis.animalItems, ["LACTOSA MONOHIDRATO", "GELATINA"])
        XCTAssertEqual(analysis.allergenItems["milk"], ["LACTOSA MONOHIDRATO"])
    }

    func testMagnesiumStearateIsDoubtfulButSoyLecithinIsVegan() {
        XCTAssertEqual(analyzeMedicine(medicine(excipients: ["ESTEARATO DE MAGNESIO"])).veganStatus, .maybe)
        let soy = analyzeMedicine(medicine(excipients: ["LECITINA DE SOJA"]))
        XCTAssertEqual(soy.veganStatus, .vegan)
        XCTAssertEqual(soy.allergenItems["soybeans"], ["LECITINA DE SOJA"])
    }

    func testWheatStarchIsFlaggedAsGluten() {
        let analysis = analyzeMedicine(medicine(excipients: ["ALMIDÓN DE TRIGO", "CELULOSA MICROCRISTALINA"]))
        XCTAssertEqual(analysis.glutenStatus, .contains)
        XCTAssertEqual(analysis.glutenItems, ["ALMIDÓN DE TRIGO"])
        XCTAssertEqual(analysis.veganStatus, .vegan)
    }

    func testLakesAndMaltodextrinAreNotFalsePositives() {
        let analysis = analyzeMedicine(medicine(excipients: ["LACA DE ALUMINIO AMARILLO", "MALTODEXTRINA", "MALTITOL"]))
        XCTAssertEqual(analysis.veganStatus, .vegan)
        XCTAssertEqual(analysis.glutenStatus, .notDeclared)
        XCTAssertTrue(analysis.allergenItems.isEmpty)
    }

    func testNoDataIsUnknown() {
        let analysis = analyzeMedicine(medicine(excipients: []))
        XCTAssertEqual(analysis.veganStatus, .unknown)
        XCTAssertEqual(analysis.glutenStatus, .unknown)
    }

    func testDescriptionMentionsDoNotDecideVerdictWhenExcipientsAreMissing() {
        let analysis = analyzeMedicine(medicine(excipients: [], extraText: "Tablets contain gelatin, wheat starch and shellac"))
        XCTAssertEqual(analysis.veganStatus, .unknown)
        XCTAssertTrue(analysis.animalItems.isEmpty)
        XCTAssertEqual(analysis.glutenStatus, .unknown)
        XCTAssertFalse(analysis.hasExcipientData)
        XCTAssertTrue(analysis.descriptionMentions.contains("gelatin"), "\(analysis.descriptionMentions)")
        XCTAssertTrue(analysis.descriptionMentions.contains("shellac"), "\(analysis.descriptionMentions)")
    }

    func testDescriptionIsIgnoredWhenExcipientsAreListed() {
        let analysis = analyzeMedicine(medicine(excipients: ["maize starch"], extraText: "Contains gelatin"))
        XCTAssertEqual(analysis.veganStatus, .vegan)
        XCTAssertTrue(analysis.descriptionMentions.isEmpty)
    }

    func testSourceQualifiedNameIncludesCountry() {
        XCTAssertEqual(MedicineSource.cima.qualifiedName, "CIMA (AEMPS) · ES")
        XCTAssertEqual(MedicineSource.openFDA.qualifiedName, "openFDA · US")
    }
}

final class MedicineModelsTests: XCTestCase {
    func testCimaJSONMapsToMedicineInfo() throws {
        let json = #"""
        {"nregistro":"12345","nombre":"IBUPROFENO TEST 600 mg","labtitular":"Lab Test","receta":true,"dosis":"600 mg",
         "formaFarmaceutica":{"nombre":"COMPRIMIDO RECUBIERTO"},
         "principiosActivos":[{"nombre":"IBUPROFENO"}],
         "excipientes":[{"nombre":"GELATINA","orden":2},{"nombre":"LACTOSA","orden":1}],
         "fotos":[{"tipo":"materialas","url":"https://example.com/a.jpg"}],
         "docs":[{"tipo":1,"url":"https://example.com/ft.pdf"},{"tipo":2,"url":"https://example.com/p.pdf","urlHtml":"https://example.com/p.html"}]}
        """#
        let medicine = try JSONDecoder().decode(CimaMedicamento.self, from: Data(json.utf8))
        let info = try XCTUnwrap(medicine.toMedicineInfo(code: "8470001234567"))
        XCTAssertEqual(info.name, "IBUPROFENO TEST 600 mg")
        XCTAssertEqual(info.excipients, ["LACTOSA", "GELATINA"])
        XCTAssertEqual(info.activeIngredients, ["IBUPROFENO"])
        XCTAssertEqual(info.pharmaceuticalForm, "COMPRIMIDO RECUBIERTO")
        XCTAssertEqual(info.leafletURL, "https://example.com/p.html")
        XCTAssertEqual(info.prescriptionRequired, true)
    }

    func testOpenFDAInactiveIngredientsAreSplit() throws {
        let json = #"""
        {"set_id":"abc","inactive_ingredient":["INACTIVE INGREDIENTS: corn starch, gelatin, magnesium stearate."],
         "openfda":{"brand_name":["Pain Relief"],"manufacturer_name":["Acme"],"substance_name":["ACETAMINOPHEN"],
                    "product_type":["HUMAN OTC DRUG"],"dosage_form":["TABLET"]}}
        """#
        let label = try JSONDecoder().decode(OpenFDALabel.self, from: Data(json.utf8))
        let info = try XCTUnwrap(label.toMedicineInfo(code: "312345678906"))
        XCTAssertEqual(info.excipients, ["corn starch", "gelatin", "magnesium stearate"])
        XCTAssertEqual(info.source, .openFDA)
        XCTAssertEqual(info.laboratory, "Acme")
        XCTAssertEqual(info.prescriptionRequired, false)
        XCTAssertEqual(info.leafletURL, "https://dailymed.nlm.nih.gov/dailymed/lookup.cfm?setid=abc")
    }
}

final class MedicineServiceTests: XCTestCase {
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: "MedicineServiceTests")
        defaults.removePersistentDomain(forName: "MedicineServiceTests")
        MedicineURLProtocolStub.reset()
    }

    private func makeService() -> MedicineService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MedicineURLProtocolStub.self]
        return MedicineService(session: URLSession(configuration: configuration), defaults: defaults)
    }

    func testSpanishBarcodeQueriesCimaAndCaches() async {
        MedicineURLProtocolStub.handler = { _ in (200, #"{"nombre":"PARACETAMOL TEST","excipientes":[{"nombre":"ALMIDÓN DE MAÍZ"}]}"#) }
        let result = await makeService().fetchMedicine(barcode: "8470007127295")
        guard case .success(let info, let fromCache) = result else { return XCTFail("Expected success, got \(result)") }
        XCTAssertFalse(fromCache)
        XCTAssertEqual(info.source, .cima)
        XCTAssertEqual(MedicineURLProtocolStub.requests.first?.absoluteString, "https://cima.aemps.es/cima/rest/medicamento?cn=712729")
        XCTAssertNotNil(defaults.data(forKey: MedicineService.cacheKey(for: "8470007127295")))
    }

    func testUSBarcodeQueriesOpenFDA() async {
        MedicineURLProtocolStub.handler = { _ in (200, #"{"results":[{"openfda":{"brand_name":["Pain Relief"]}}]}"#) }
        let result = await makeService().fetchMedicine(barcode: "312345678906")
        guard case .success(let info, _) = result else { return XCTFail("Expected success, got \(result)") }
        XCTAssertEqual(info.source, .openFDA)
        let url = MedicineURLProtocolStub.requests.first?.absoluteString ?? ""
        XCTAssertTrue(url.hasPrefix("https://api.fda.gov/drug/label.json?search=openfda.upc:%22312345678906%22+OR+"), url)
    }

    func testNotFoundResponse() async {
        MedicineURLProtocolStub.handler = { _ in (404, #"{"error":{"code":"NOT_FOUND"}}"#) }
        let result = await makeService().fetchMedicine(barcode: "312345678906")
        XCTAssertEqual(result, .notFound([.openFDA]))
    }

    func testTransportErrorFallsBackToCache() async {
        let cached = MedicineInfo(code: "8470007127295", source: .cima, name: "Cached", activeIngredients: [], excipients: [])
        defaults.set(try? JSONEncoder().encode(cached), forKey: MedicineService.cacheKey(for: "8470007127295"))
        MedicineURLProtocolStub.handler = nil
        let result = await makeService().fetchMedicine(barcode: "8470007127295")
        XCTAssertEqual(result, .success(cached, fromCache: true))
    }

    func testTransportErrorWithoutCacheIsError() async {
        MedicineURLProtocolStub.handler = nil
        let result = await makeService().fetchMedicine(barcode: "8470007127295")
        guard case .error = result else { return XCTFail("Expected error, got \(result)") }
    }

    func testNameSearchQueriesBothSourcesAndMapsResults() async {
        MedicineURLProtocolStub.handler = { request in
            if request.url?.host == "cima.aemps.es" {
                return (200, #"{"totalFilas":1,"resultados":[{"nregistro":"64101","nombre":"IBUPROFENO CINFA","labtitular":"Cinfa"}]}"#)
            }
            return (200, #"{"results":[{"set_id":"abc-123","openfda":{"brand_name":["Advil"]}}]}"#)
        }
        let result = await makeService().searchByName(query: "ibu profeno")
        guard case .success(let items) = result else { return XCTFail("Expected success, got \(result)") }
        XCTAssertEqual(items.map(\.code), ["cima-64101", "fda-abc-123"])
        XCTAssertEqual(items.first?.laboratory, "Cinfa")
        let urls = MedicineURLProtocolStub.requests.map(\.absoluteString)
        XCTAssertTrue(urls.contains("https://cima.aemps.es/cima/rest/medicamentos?nombre=ibu%20profeno&comerc=1"), "\(urls)")
        let fdaURL = urls.first { $0.hasPrefix("https://api.fda.gov/drug/label.json?search=") } ?? ""
        XCTAssertTrue(fdaURL.contains("openfda.brand_name:%22ibu%20profeno%22+OR+openfda.generic_name:"), fdaURL)
    }

    func testNameSearchKeepsResultsWhenOneSourceFails() async {
        MedicineURLProtocolStub.handler = { request in
            if request.url?.host == "cima.aemps.es" { return (500, "") }
            return (200, #"{"results":[{"set_id":"abc","openfda":{"brand_name":["Advil"]}}]}"#)
        }
        let result = await makeService().searchByName(query: "advil")
        XCTAssertEqual(
            result,
            .partial(
                [MedicineSearchItem(code: "fda-abc", name: "Advil", laboratory: nil, imageURL: nil, source: .openFDA)],
                unavailable: .cima
            )
        )
    }

    func testNameSearchEmptyAndTransportError() async {
        MedicineURLProtocolStub.handler = { _ in (200, #"{"resultados":[]}"#) }
        let empty = await makeService().searchByName(query: "zzz")
        XCTAssertEqual(empty, .empty)
        let blank = await makeService().searchByName(query: "  ")
        XCTAssertEqual(blank, .empty)
        MedicineURLProtocolStub.handler = { _ in (404, "") }
        let notFound = await makeService().searchByName(query: "x")
        XCTAssertEqual(notFound, .empty)
        MedicineURLProtocolStub.handler = { _ in (503, "") }
        let unavailable = await makeService().searchByName(query: "x")
        XCTAssertEqual(unavailable, .unavailable)
    }

    func testSearchCodesOpenTheirSource() async {
        MedicineURLProtocolStub.handler = { _ in (200, #"{"nregistro":"64101","nombre":"IBUPROFENO"}"#) }
        let cima = await makeService().fetchMedicine(barcode: "cima-64101")
        guard case .success(let info, _) = cima else { return XCTFail("Expected success, got \(cima)") }
        XCTAssertEqual(info.name, "IBUPROFENO")
        XCTAssertEqual(MedicineURLProtocolStub.requests.last?.absoluteString, "https://cima.aemps.es/cima/rest/medicamento?nregistro=64101")

        MedicineURLProtocolStub.handler = { _ in (200, #"{"results":[{"set_id":"abc-1","openfda":{"brand_name":["Advil"]}}]}"#) }
        let fda = await makeService().fetchMedicine(barcode: "fda-abc-1")
        guard case .success(let fdaInfo, _) = fda else { return XCTFail("Expected success, got \(fda)") }
        XCTAssertEqual(fdaInfo.source, .openFDA)
        XCTAssertEqual(MedicineURLProtocolStub.requests.last?.absoluteString, "https://api.fda.gov/drug/label.json?search=set_id:%22abc-1%22&limit=1")
    }
}

private final class MedicineURLProtocolStub: URLProtocol {
    static var handler: ((URLRequest) -> (Int, String))?
    static var requests: [URL] = []

    static func reset() {
        handler = nil
        requests = []
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let url = request.url { Self.requests.append(url) }
        guard let handler = Self.handler, let url = request.url else {
            client?.urlProtocol(self, didFailWithError: URLError(.notConnectedToInternet))
            return
        }
        let (status, body) = handler(request)
        let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data(body.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
