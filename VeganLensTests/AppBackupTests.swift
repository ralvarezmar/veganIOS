import XCTest
@testable import VeganLens

final class AppBackupTests: XCTestCase {
    func testRoundTripsThroughJSON() throws {
        let backup = AppBackup(
            exportedAt: 99,
            history: [BackupHistoryEntry(barcode: "1", productName: "P", timestamp: 10, verdict: "VEGAN", category: "BEVERAGES")],
            favorites: [BackupFavoriteEntry(barcode: "2", imageUrl: "https://img", addedAt: 20, verdict: "MAYBE")],
            shoppingList: [BackupShoppingEntry(barcode: "3", brand: "Brand", addedAt: 30, verdict: "NOT_VEGAN", checked: true)]
        )

        XCTAssertEqual(decodeBackup(try encodeBackup(backup)), backup)
    }

    func testDecodesSharedCrossPlatformFormat() throws {
        let json = """
        {"format":"veganlens-backup","version":1,"exportedAt":5,
         "history":[{"barcode":"1","timestamp":7,"verdict":"VEGAN"}],
         "favorites":[{"barcode":"2","addedAt":8}],
         "shoppingList":[{"barcode":"3","addedAt":9,"checked":true}]}
        """
        let decoded = try XCTUnwrap(decodeBackup(Data(json.utf8)))

        XCTAssertEqual(decoded.history?.first?.barcode, "1")
        XCTAssertEqual(decoded.history?.first?.timestamp, 7)
        XCTAssertEqual(decoded.shoppingList?.first?.checked, true)
    }

    func testRejectsInvalidOrForeignFiles() {
        XCTAssertNil(decodeBackup(Data("not json".utf8)))
        XCTAssertNil(decodeBackup(Data(#"{"format":"other","version":1}"#.utf8)))
        XCTAssertNil(decodeBackup(Data(#"{"format":"veganlens-backup","version":99}"#.utf8)))
        XCTAssertNil(decodeBackup(Data("[]".utf8)))
    }

    func testMergeAddsMissingAndOnlyUpdatesNewerHistory() {
        let backup = AppBackup(
            history: [
                BackupHistoryEntry(barcode: ""),
                BackupHistoryEntry(barcode: nil),
                BackupHistoryEntry(barcode: "new", timestamp: 5),
                BackupHistoryEntry(barcode: "newer", timestamp: 50),
                BackupHistoryEntry(barcode: "older", timestamp: 1),
            ],
            favorites: [BackupFavoriteEntry(barcode: "fav-existing"), BackupFavoriteEntry(barcode: "fav-new")],
            shoppingList: [BackupShoppingEntry(barcode: "shop-existing"), BackupShoppingEntry(barcode: "shop-new")]
        )

        let plan = planBackupMerge(
            backup,
            existingHistory: ["newer": backupDate(10), "older": backupDate(10)],
            existingFavoriteBarcodes: ["fav-existing"],
            existingShoppingBarcodes: ["shop-existing"]
        )

        XCTAssertEqual(plan.historyToInsert.map(\.barcode), ["new"])
        XCTAssertEqual(plan.historyToUpdate.map(\.barcode), ["newer"])
        XCTAssertEqual(plan.historyCount, 2)
        XCTAssertEqual(plan.favoritesToInsert.map(\.barcode), ["fav-new"])
        XCTAssertEqual(plan.shoppingToInsert.map(\.barcode), ["shop-new"])
    }
}
