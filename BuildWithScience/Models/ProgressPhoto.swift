import Foundation
import SwiftData

@Model
final class ProgressPhoto {
    var id: UUID
    var date: Date
    var imageData: Data
    var category: String
    var note: String

    init(
        id: UUID = UUID(),
        date: Date = .now,
        imageData: Data,
        category: String = "Front",
        note: String = ""
    ) {
        self.id = id
        self.date = date
        self.imageData = imageData
        self.category = category
        self.note = note
    }
}
