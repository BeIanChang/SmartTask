import SwiftUI

struct WeekStripView: View {
    let dates: [Date]
    @Binding var selectedDate: Date

    private let calendar = Calendar.current

    var body: some View {
        HStack(spacing: 12) {
            ForEach(dates, id: \.self) { date in
                VStack(spacing: 6) {
                    Text(weekdaySymbol(for: date))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(calendar.component(.day, from: date))")
                        .font(.headline)
                        .frame(width: 36, height: 36)
                        .background(isSelected(date) ? Color.purple.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                }
                .onTapGesture {
                    selectedDate = Calendar.current.startOfDay(for: date)
                }
            }
        }
    }

    private func weekdaySymbol(for date: Date) -> String {
        let weekdayIndex = calendar.component(.weekday, from: date) - 1
        return calendar.shortWeekdaySymbols[weekdayIndex]
    }

    private func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
}
