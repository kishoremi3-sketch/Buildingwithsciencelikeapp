import Foundation
import SwiftData

@Model
final class LoggedExercise {
    var id: UUID
    var exerciseName: String
    var order: Int
    var session: WorkoutSession?

    @Relationship(deleteRule: .cascade, inverse: \LoggedSet.loggedExercise)
    var sets: [LoggedSet]

    init(
        id: UUID = UUID(),
        exerciseName: String,
        order: Int,
        sets: [LoggedSet] = []
    ) {
        self.id = id
        self.exerciseName = exerciseName
        self.order = order
        self.sets = sets
    }
}
