import SwiftUI
import UIKit

struct FoodEntryRow: View {
    let entry: FoodEntry

    var body: some View {
        HStack(spacing: 12) {
            if let data = entry.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 52, height: 52)
                    .overlay {
                        Image(systemName: "fork.knife")
                            .foregroundStyle(.secondary)
                    }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name).font(.subheadline.bold())
                Text("\(Int(entry.proteinG))P · \(Int(entry.carbsG))C · \(Int(entry.fatG))F")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(entry.calories) kcal")
                .font(.caption.bold())
        }
        .padding()
        .background(BWSTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
