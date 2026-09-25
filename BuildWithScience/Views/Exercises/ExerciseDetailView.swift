import SwiftUI
import AVKit

struct ExerciseDetailView: View {
    let exercise: Exercise

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                videoSection

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Tag(text: exercise.primaryMuscle, tint: BWSTheme.primary)
                        Tag(text: exercise.equipment, tint: .gray)
                    }
                    if !exercise.secondaryMuscles.isEmpty {
                        Text("Also works: \(exercise.secondaryMuscles.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("How to Perform").font(.headline)
                    Text(exercise.instructions)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var videoSection: some View {
        if let url = exercise.videoURL {
            VideoPlayer(player: AVPlayer(url: url))
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [BWSTheme.primary.opacity(0.15), BWSTheme.accent.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing))
                VStack(spacing: 8) {
                    Image(systemName: "video.slash")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text("No demo video yet")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 180)
        }
    }
}

private struct Tag: View {
    let text: String
    let tint: Color

    var body: some View {
        Text(text)
            .font(.caption.bold())
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(tint.opacity(0.15))
            .foregroundStyle(tint)
            .clipShape(Capsule())
    }
}
