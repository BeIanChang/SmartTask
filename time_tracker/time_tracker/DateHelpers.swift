import Foundation

extension Calendar {
    func startOfDay(for date: Date, in timeZone: TimeZone = .current) -> Date {
        var calendar = self
        calendar.timeZone = timeZone
        return calendar.startOfDay(for: date)
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
    }
}
