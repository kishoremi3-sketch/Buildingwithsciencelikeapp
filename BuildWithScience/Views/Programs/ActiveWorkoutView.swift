import SwiftUI
import SwiftData

struct ActiveWorkoutView: View {
    let day: WorkoutDayTemplate
    let programName: String

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var timer = RestTimerManager()

    @State private var session: WorkoutSession
    @State private var startedAt = Date.now
    @State private var showRestTimer = false
    @State private var showFinishConfirm = false

    init(day: WorkoutDayTemplate, programName: String) {
        self.day = day
        self.programName = programName

        let loggedExercises = day.exercises.sorted { $0.order < $1.order }.map { template -> LoggedExercise in
            let sets = (1...template.targetSets).map { LoggedSet(setNumber: $0) }
            return LoggedExercise(exerciseName: template.exerciseName, order: template.order, sets: sets)
        }
        _session = State(initialValue: WorkoutSession(dayName: day.name, loggedExercises: loggedExercises))
    }

    private var sortedLoggedExercises: [LoggedExercise] {
        session.loggedExercises.sorted { $0.order < $1.order }
    }

    private var completedSetsCount: Int {
        session.loggedExercises.flatMap(\.sets).filter(\.isCompleted).count
    }

    private var totalSetsCount: Int {
        session.loggedExercises.flatMap(\.sets).count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                progressHeader

                ForEach(sortedLoggedExercises) { exercise in
                    exerciseCard(for: exercise)
                }
            }
            .padding()
        }
        .background(BWSTheme.screenBackground)
        .navigationTitle(day.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Finish") { showFinishConfirm = true }
                    .fontWeight(.bold)
            }
        }
        .sheet(isPresented: $showRestTimer) {
            RestTimerSheet(timer: timer)
                .presentationDetents([.height(320)])
        }
        .confirmationDialog("Finish workout?", isPresented: $showFinishConfirm, titleVisibility: .visible) {
            Button("Finish & Save") { finishWorkout() }
            Button("Cancel", role: .cancel) {}
        }
    }

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(programName)
                .font(.caption)
                .foregroundStyle(.secondary)
            ProgressView(value: Double(completedSetsCount), total: Double(max(totalSetsCount, 1)))
                .tint(BWSTheme.accent)
            Text("\(completedSetsCount) of \(totalSetsCount) sets complete")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func exerciseCard(for exercise: LoggedExercise) -> some View {
        let template = day.exercises.first { $0.exerciseName == exercise.exerciseName }

        return VStack(alignment: .leading, spacing: 12) {
            Text(exercise.exerciseName)
                .font(.headline)

            ForEach(exercise.sets.sorted { $0.setNumber < $1.setNumber }) { set in
                SetRowView(set: set, targetReps: template?.repRangeText ?? "reps")
                    .onChange(of: set.isCompleted) { _, isCompleted in
                        if isCompleted {
                            timer.start(seconds: template?.restSeconds ?? 90)
                            showRestTimer = true
                        }
                    }
            }

            Button {
                addSet(to: exercise)
            } label: {
                Label("Add Set", systemImage: "plus.circle")
                    .font(.caption.bold())
            }
        }
        .padding()
        .background(BWSTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func addSet(to exercise: LoggedExercise) {
        let nextNumber = (exercise.sets.map(\.setNumber).max() ?? 0) + 1
        exercise.sets.append(LoggedSet(setNumber: nextNumber))
    }

    private func finishWorkout() {
        session.durationMinutes = max(1, Int(Date.now.timeIntervalSince(startedAt) / 60))
        session.isCompleted = true
        context.insert(session)
        try? context.save()
        dismiss()
    }
}
