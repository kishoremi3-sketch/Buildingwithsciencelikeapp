import SwiftUI

struct WorkoutDayDetailView: View {
    let day: WorkoutDayTemplate
    let programName: String

    private var sortedExercises: [ProgramExerciseTemplate] {
        day.exercises.sorted { $0.order < $1.order }
    }

    var body: some View {
        List {
            Section {
                ForEach(sortedExercises) { exercise in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(exercise.exerciseName).font(.subheadline.bold())
                        Text("\(exercise.targetSets) sets · \(exercise.repRangeText) reps · \(exercise.restSeconds)s rest")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }

            Section {
                NavigationLink {
                    ActiveWorkoutView(day: day, programName: programName)
                } label: {
                    Label("Start Workout", systemImage: "play.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .listRowBackground(BWSTheme.primary)
                .foregroundStyle(.white)
            }
        }
        .navigationTitle(day.name)
    }
}
