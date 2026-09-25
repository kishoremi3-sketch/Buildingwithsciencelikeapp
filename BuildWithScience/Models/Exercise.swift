import Foundation
import SwiftData

@Model
final class Exercise {
    var id: UUID
    var name: String
    var primaryMuscle: String
    var secondaryMuscles: [String]
    var equipment: String
    var instructions: String
    var steps: [String]
    var coachingTip: String
    var videoURLString: String?
    var videoSourceName: String?
    var isCompound: Bool

    init(
        id: UUID = UUID(),
        name: String,
        primaryMuscle: String,
        secondaryMuscles: [String] = [],
        equipment: String,
        instructions: String,
        steps: [String] = [],
        coachingTip: String = "",
        videoURLString: String? = nil,
        videoSourceName: String? = nil,
        isCompound: Bool = true
    ) {
        self.id = id
        self.name = name
        self.primaryMuscle = primaryMuscle
        self.secondaryMuscles = secondaryMuscles
        self.equipment = equipment
        self.instructions = instructions
        self.steps = steps
        self.coachingTip = coachingTip
        self.videoURLString = videoURLString
        self.videoSourceName = videoSourceName
        self.isCompound = isCompound
    }

    var videoURL: URL? {
        guard let videoURLString else { return nil }
        return URL(string: videoURLString)
    }
}
