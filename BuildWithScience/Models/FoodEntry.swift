import Foundation
import SwiftData

@Model
final class FoodEntry {
    var id: UUID
    var date: Date
    var mealType: String
    var name: String
    var photoData: Data?
    var calories: Int
    var proteinG: Double
    var carbsG: Double
    var fatG: Double
    var notes: String
    var isEstimated: Bool

    init(
        id: UUID = UUID(),
        date: Date = .now,
        mealType: String,
        name: String,
        photoData: Data? = nil,
        calories: Int = 0,
        proteinG: Double = 0,
        carbsG: Double = 0,
        fatG: Double = 0,
        notes: String = "",
        isEstimated: Bool = false
    ) {
        self.id = id
        self.date = date
        self.mealType = mealType
        self.name = name
        self.photoData = photoData
        self.calories = calories
        self.proteinG = proteinG
        self.carbsG = carbsG
        self.fatG = fatG
        self.notes = notes
        self.isEstimated = isEstimated
    }
}
