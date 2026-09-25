import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var dailyCalorieGoal: Int
    var proteinGoalG: Double
    var carbsGoalG: Double
    var fatGoalG: Double
    var startingWeightKg: Double
    var goalWeightKg: Double
    var activeProgramID: UUID?

    init(
        id: UUID = UUID(),
        name: String = "Athlete",
        dailyCalorieGoal: Int = 2400,
        proteinGoalG: Double = 180,
        carbsGoalG: Double = 250,
        fatGoalG: Double = 70,
        startingWeightKg: Double = 80,
        goalWeightKg: Double = 75,
        activeProgramID: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.dailyCalorieGoal = dailyCalorieGoal
        self.proteinGoalG = proteinGoalG
        self.carbsGoalG = carbsGoalG
        self.fatGoalG = fatGoalG
        self.startingWeightKg = startingWeightKg
        self.goalWeightKg = goalWeightKg
        self.activeProgramID = activeProgramID
    }
}
