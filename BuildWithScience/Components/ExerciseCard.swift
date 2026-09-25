import SwiftUI

struct ExerciseCard: View {
    let exercise: Exercise

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(BWSTheme.primary.opacity(0.12))
                .frame(width: 48, height: 48)
                .overlay {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .foregroundStyle(BWSTheme.primary)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(exercise.name).font(.subheadline.bold())
                Text("\(exercise.primaryMuscle) · \(exercise.equipment)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
