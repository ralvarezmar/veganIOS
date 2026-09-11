import XCTest
@testable import VeganLens

final class UndoDeletionTests: XCTestCase {
    func testScanFactoryPreservesAllFields() {
        let date = Date(timeIntervalSince1970: 123)
        let snapshot = DeletedScanSnapshot(
            barcode: "123",
            productName: "Product",
            brand: "Brand",
            imageURL: "https://example.test/image",
            timestamp: date,
            verdict: VeganStatus.maybe.persistedValue,
            category: ProductCategory.beverages.rawValue
        )

        let record = makeScanRecord(from: snapshot)

        XCTAssertEqual(record.barcode, snapshot.barcode)
        XCTAssertEqual(record.productName, snapshot.productName)
        XCTAssertEqual(record.brand, snapshot.brand)
        XCTAssertEqual(record.imageURL, snapshot.imageURL)
        XCTAssertEqual(record.timestamp, date)
        XCTAssertEqual(record.verdict, VeganStatus.maybe.persistedValue)
        XCTAssertEqual(record.category, ProductCategory.beverages.rawValue)
    }

    func testFavoriteFactoryPreservesAllFields() {
        let date = Date(timeIntervalSince1970: 456)
        let snapshot = DeletedFavoriteSnapshot(
            barcode: "456",
            productName: "Product",
            brand: "Brand",
            imageURL: "https://example.test/image",
            addedAt: date,
            verdict: VeganStatus.vegan.persistedValue,
            category: ProductCategory.petFood.rawValue
        )

        let favorite = makeFavoriteProduct(from: snapshot)

        XCTAssertEqual(favorite.barcode, snapshot.barcode)
        XCTAssertEqual(favorite.productName, snapshot.productName)
        XCTAssertEqual(favorite.brand, snapshot.brand)
        XCTAssertEqual(favorite.imageURL, snapshot.imageURL)
        XCTAssertEqual(favorite.addedAt, date)
        XCTAssertEqual(favorite.verdict, VeganStatus.vegan.persistedValue)
        XCTAssertEqual(favorite.category, ProductCategory.petFood.rawValue)
    }
}
