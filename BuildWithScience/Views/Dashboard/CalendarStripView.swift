import SwiftUI

struct CalendarStripView: View {
    @Binding var selectedDate: Date
    let completedDates: Set<Date>

    private var days: [Date] { Date.daysInCurrentWeek() }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(days, id: \.self) { day in
                VStack(spacing: 6) {
                    Text(day.shortWeekdaySymbol)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(day.dayNumber)
                        .font(.subheadline.bold())
                        .frame(width: 32, height: 32)
                        .background(day.isSameDay(as: selectedDate) ? BWSTheme.primary : Color.clear)
                        .foregroundStyle(day.isSameDay(as: selectedDate) ? .white : .primary)
                        .clipShape(Circle())

                    Circle()
                        .fill(completedDates.contains(day.startOfDay) ? BWSTheme.accent : .clear)
                        .frame(width: 5, height: 5)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture { selectedDate = day }
            }
        }
        .padding(.vertical, 8)
    }
}
