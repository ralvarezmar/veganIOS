import Foundation
import UserNotifications

enum B12ReminderSettings {
    static let enabledKey = "b12_reminder_enabled"
    static let hourKey = "b12_reminder_hour"
    static let minuteKey = "b12_reminder_minute"
    static let intervalDaysKey = "b12_reminder_interval_days"
    static let weekdaysKey = "b12_reminder_weekdays"
    static let requestPrefix = "b12-reminder-"
    static let weekdaysMode = 0
    static let allWeekdays = 0b1111111
}

func b12WeekdayBit(_ isoWeekday: Int) -> Int {
    1 << (isoWeekday - 1)
}

func b12IsoWeekday(of date: Date, calendar: Calendar) -> Int {
    (calendar.component(.weekday, from: date) + 5) % 7 + 1
}

func b12ReminderDates(
    from: Date,
    hour: Int,
    minute: Int,
    intervalDays: Int,
    weekdays: Int = B12ReminderSettings.allWeekdays,
    count: Int,
    calendar: Calendar
) -> [Date] {
    guard count > 0 else { return [] }

    let startOfDay = calendar.startOfDay(for: from)
    guard var nextDate = calendar.date(
        bySettingHour: hour,
        minute: minute,
        second: 0,
        of: startOfDay
    ) else {
        return []
    }
    if nextDate <= from {
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: nextDate) else {
            return []
        }
        nextDate = tomorrow
    }

    if intervalDays == B12ReminderSettings.weekdaysMode {
        let selected = weekdays & B12ReminderSettings.allWeekdays
        let mask = selected == 0 ? B12ReminderSettings.allWeekdays : selected
        var dates: [Date] = []
        var day = nextDate
        while dates.count < count {
            if mask & b12WeekdayBit(b12IsoWeekday(of: day, calendar: calendar)) != 0 {
                dates.append(day)
            }
            guard let following = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = following
        }
        return dates
    }

    let interval = max(intervalDays, 1)
    var dates: [Date] = []
    for _ in 0..<count {
        dates.append(nextDate)
        guard let followingDate = calendar.date(byAdding: .day, value: interval, to: nextDate) else {
            break
        }
        nextDate = followingDate
    }
    return dates
}

enum B12ReminderScheduler {
    static func refreshIfEnabled() {
        guard UserDefaults.standard.bool(forKey: B12ReminderSettings.enabledKey) else {
            Task {
                await removePendingReminders()
            }
            return
        }
        Task {
            await refresh()
        }
    }

    static func refresh() async {
        guard UserDefaults.standard.bool(forKey: B12ReminderSettings.enabledKey) else {
            await removePendingReminders()
            return
        }

        await removePendingReminders()
        let calendar = Calendar.current
        let dates = b12ReminderDates(
            from: Date(),
            hour: UserDefaults.standard.integer(forKey: B12ReminderSettings.hourKey),
            minute: UserDefaults.standard.integer(forKey: B12ReminderSettings.minuteKey),
            intervalDays: UserDefaults.standard.integer(forKey: B12ReminderSettings.intervalDaysKey),
            weekdays: UserDefaults.standard.object(forKey: B12ReminderSettings.weekdaysKey) as? Int
                ?? B12ReminderSettings.allWeekdays,
            count: 30,
            calendar: calendar
        )

        let center = UNUserNotificationCenter.current()
        for (index, date) in dates.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = L("b12_reminder_title")
            content.body = L("b12_reminder_notification")
            content.sound = .default
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: date
            )
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )
            let request = UNNotificationRequest(
                identifier: "\(B12ReminderSettings.requestPrefix)\(index)",
                content: content,
                trigger: trigger
            )
            try? await center.add(request)
        }
    }

    static func removePendingReminders() async {
        let center = UNUserNotificationCenter.current()
        let identifiers: [String] = await withCheckedContinuation {
            (continuation: CheckedContinuation<[String], Never>) in
            center.getPendingNotificationRequests { requests in
                continuation.resume(
                    returning: requests
                        .map(\.identifier)
                        .filter { $0.hasPrefix(B12ReminderSettings.requestPrefix) }
                )
            }
        }
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
