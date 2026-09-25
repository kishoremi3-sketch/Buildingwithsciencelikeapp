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
    var videoURLString: String?
    var isCompound: Bool

    init(
        id: UUID = UUID(),
        name: String,
        primaryMuscle: String,
        secondaryMuscles: [String] = [],
        equipment: String,
        instructions: String,
        videoURLString: String? = nil,
        isCompound: Bool = true
    ) {
        self.id = id
        self.name = name
        self.primaryMuscle = primaryMuscle
        self.secondaryMuscles = secondaryMuscles
        self.equipment = equipment
        self.instructions = instructions
        self.videoURLString = videoURLString
        self.isCompound = isCompound
    }

    var videoURL: URL? {
        guard let videoURLString else { return nil }
        return URL(string: videoURLString)
    }
}
