import SwiftUI

struct ProgramDayCard: View {
    let day: WorkoutDayTemplate

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(day.name).font(.subheadline.bold())
            Text(day.exercises.sorted { $0.order < $1.order }.map(\.exerciseName).joined(separator: ", "))
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}
