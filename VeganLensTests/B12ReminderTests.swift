import XCTest
@testable import VeganLens

final class B12ReminderTests: XCTestCase {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Madrid")!
        return calendar
    }

    func testPastTimeUsesTomorrow() {
        let now = date("2026-03-10 10:00")

        let dates = b12ReminderDates(
            from: now,
            hour: 9,
            minute: 30,
            intervalDays: 1,
            count: 1,
            calendar: calendar
        )

        XCTAssertEqual(dates, [date("2026-03-11 09:30")])
    }

    func testUpcomingTimeUsesToday() {
        let now = date("2026-03-10 08:00")

        let dates = b12ReminderDates(
            from: now,
            hour: 9,
            minute: 30,
            intervalDays: 1,
            count: 1,
            calendar: calendar
        )

        XCTAssertEqual(dates, [date("2026-03-10 09:30")])
    }

    func testThreeDayIntervalAfterYesterdayFiringUsesTwoDaysLater() {
        let now = date("2026-03-11 08:00")
        let dates = b12ReminderDates(
            from: now,
            hour: 9,
            minute: 30,
            intervalDays: 3,
            count: 2,
            calendar: calendar
        )

        XCTAssertEqual(dates.first, date("2026-03-11 09:30"))
        XCTAssertEqual(dates.dropFirst().first, date("2026-03-14 09:30"))
    }

    func testSevenDayInterval() {
        let now = date("2026-03-10 08:00")

        let dates = b12ReminderDates(
            from: now,
            hour: 9,
            minute: 30,
            intervalDays: 7,
            count: 2,
            calendar: calendar
        )

        XCTAssertEqual(dates, [date("2026-03-10 09:30"), date("2026-03-17 09:30")])
    }

    func testMonthTransition() {
        let now = date("2026-01-31 10:00")

        let dates = b12ReminderDates(
            from: now,
            hour: 9,
            minute: 30,
            intervalDays: 3,
            count: 1,
            calendar: calendar
        )

        XCTAssertEqual(dates, [date("2026-02-01 09:30")])
    }

    func testReturnsExactlyCountSortedFutureDates() {
        let now = date("2026-03-10 08:00")

        let dates = b12ReminderDates(
            from: now,
            hour: 9,
            minute: 30,
            intervalDays: 3,
            count: 30,
            calendar: calendar
        )

        XCTAssertEqual(dates.count, 30)
        XCTAssertEqual(dates, dates.sorted())
        XCTAssertTrue(dates.allSatisfy { $0 > now })
    }

    private func date(_ value: String) -> Date {
        let parts = value.split(separator: " ")
        let dateParts = parts[0].split(separator: "-").map { Int($0)! }
        let timeParts = parts[1].split(separator: ":").map { Int($0)! }
        return calendar.date(
            from: DateComponents(
                calendar: calendar,
                timeZone: calendar.timeZone,
                year: dateParts[0],
                month: dateParts[1],
                day: dateParts[2],
                hour: timeParts[0],
                minute: timeParts[1]
            )
        )!
    }
}
