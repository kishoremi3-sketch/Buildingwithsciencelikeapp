import Foundation
import SwiftData

@Model
final class WorkoutDayTemplate {
    var id: UUID
    var name: String
    var order: Int
    var program: WorkoutProgram?

    @Relationship(deleteRule: .cascade, inverse: \ProgramExerciseTemplate.day)
    var exercises: [ProgramExerciseTemplate]

    init(
        id: UUID = UUID(),
        name: String,
        order: Int,
        exercises: [ProgramExerciseTemplate] = []
    ) {
        self.id = id
        self.name = name
        self.order = order
        self.exercises = exercises
    }
}
