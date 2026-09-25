import Foundation
import SwiftData

@Model
final class WorkoutSession {
    var id: UUID
    var date: Date
    var dayName: String
    var durationMinutes: Int
    var notes: String
    var isCompleted: Bool

    @Relationship(deleteRule: .cascade, inverse: \LoggedExercise.session)
    var loggedExercises: [LoggedExercise]

    init(
        id: UUID = UUID(),
        date: Date = .now,
        dayName: String,
        durationMinutes: Int = 0,
        notes: String = "",
        isCompleted: Bool = false,
        loggedExercises: [LoggedExercise] = []
    ) {
        self.id = id
        self.date = date
        self.dayName = dayName
        self.durationMinutes = durationMinutes
        self.notes = notes
        self.isCompleted = isCompleted
        self.loggedExercises = loggedExercises
    }
}
