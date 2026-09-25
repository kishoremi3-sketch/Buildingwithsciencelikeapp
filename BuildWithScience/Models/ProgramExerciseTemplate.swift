import Foundation
import SwiftData

@Model
final class ProgramExerciseTemplate {
    var id: UUID
    var exerciseName: String
    var targetSets: Int
    var targetRepsLow: Int
    var targetRepsHigh: Int
    var restSeconds: Int
    var order: Int
    var day: WorkoutDayTemplate?

    init(
        id: UUID = UUID(),
        exerciseName: String,
        targetSets: Int,
        targetRepsLow: Int,
        targetRepsHigh: Int,
        restSeconds: Int,
        order: Int
    ) {
        self.id = id
        self.exerciseName = exerciseName
        self.targetSets = targetSets
        self.targetRepsLow = targetRepsLow
        self.targetRepsHigh = targetRepsHigh
        self.restSeconds = restSeconds
        self.order = order
    }

    var repRangeText: String { "\(targetRepsLow)-\(targetRepsHigh)" }
}
