import Foundation
import SwiftData

@Model
final class LoggedSet {
    var id: UUID
    var setNumber: Int
    var weight: Double
    var reps: Int
    var isWarmup: Bool
    var isCompleted: Bool
    var loggedExercise: LoggedExercise?

    init(
        id: UUID = UUID(),
        setNumber: Int,
        weight: Double = 0,
        reps: Int = 0,
        isWarmup: Bool = false,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.setNumber = setNumber
        self.weight = weight
        self.reps = reps
        self.isWarmup = isWarmup
        self.isCompleted = isCompleted
    }
}
