import Foundation
import Vision
import UIKit

struct FoodPhotoEstimate {
    let label: String
    let confidence: Float
    let nutrition: NutritionFacts?
}

/// Uses the general-purpose image classifier built into iOS (Vision's
/// `VNClassifyImageRequest`, backed by an on-device Apple model — no network
/// call, no custom-trained food model). It is not food-specialized, so
/// results are matched against a small local nutrition table and should
/// always be reviewed by the user rather than trusted outright.
enum FoodPhotoEstimator {
    static func estimate(from image: UIImage) async -> FoodPhotoEstimate? {
        guard let cgImage = image.cgImage else { return nil }
        let request = VNClassifyImageRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        do {
            try handler.perform([request])
        } catch {
            return nil
        }

        guard let observations = request.results, let top = observations.first else { return nil }

        let foodMatch = observations
            .sorted { $0.confidence > $1.confidence }
            .first { NutritionDatabase.lookup(label: $0.identifier) != nil }

        guard let match = foodMatch else {
            return FoodPhotoEstimate(label: top.identifier, confidence: top.confidence, nutrition: nil)
        }

        return FoodPhotoEstimate(
            label: match.identifier,
            confidence: match.confidence,
            nutrition: NutritionDatabase.lookup(label: match.identifier)
        )
    }
}
