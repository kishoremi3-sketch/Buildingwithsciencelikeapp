import Foundation
import SwiftData

@Model
final class WorkoutProgram {
    var id: UUID
    var name: String
    var summary: String
    var durationWeeks: Int
    var focus: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \WorkoutDayTemplate.program)
    var days: [WorkoutDayTemplate]

    init(
        id: UUID = UUID(),
        name: String,
        summary: String,
        durationWeeks: Int,
        focus: String,
        days: [WorkoutDayTemplate] = [],
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.durationWeeks = durationWeeks
        self.focus = focus
        self.days = days
        self.createdAt = createdAt
    }
}
