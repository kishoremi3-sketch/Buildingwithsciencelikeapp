import Foundation
import SwiftData

@Model
final class BodyMetricEntry {
    var id: UUID
    var date: Date
    var weightKg: Double
    var bodyFatPercent: Double?
    var notes: String

    init(
        id: UUID = UUID(),
        date: Date = .now,
        weightKg: Double,
        bodyFatPercent: Double? = nil,
        notes: String = ""
    ) {
        self.id = id
        self.date = date
        self.weightKg = weightKg
        self.bodyFatPercent = bodyFatPercent
        self.notes = notes
    }
}
