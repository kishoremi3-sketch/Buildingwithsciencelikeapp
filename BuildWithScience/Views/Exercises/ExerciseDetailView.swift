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
                    Text("Setup").font(.headline)
                    Text(exercise.instructions)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                if !exercise.steps.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Steps").font(.headline)
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(exercise.steps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 10) {
                                    Text("\(index + 1)")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                        .frame(width: 20, height: 20)
                                        .background(BWSTheme.primary)
                                        .clipShape(Circle())
                                    Text(step)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }

                if !exercise.coachingTip.isEmpty {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(BWSTheme.accent)
                        Text(exercise.coachingTip)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(BWSTheme.accent.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
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
