import Foundation
import UserNotifications

enum B12ReminderSettings {
    static let enabledKey = "b12_reminder_enabled"
    static let hourKey = "b12_reminder_hour"
    static let minuteKey = "b12_reminder_minute"
    static let intervalDaysKey = "b12_reminder_interval_days"
    static let requestPrefix = "b12-reminder-"
}

func b12ReminderDates(
    from: Date,
    hour: Int,
    minute: Int,
    intervalDays: Int,
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
