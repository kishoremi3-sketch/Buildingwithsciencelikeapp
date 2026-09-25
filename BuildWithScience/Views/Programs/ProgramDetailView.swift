import SwiftUI
import SwiftData

struct ProgramDetailView: View {
    @Bindable var program: WorkoutProgram
    @Query private var profiles: [UserProfile]
    @Environment(\.modelContext) private var context

    private var sortedDays: [WorkoutDayTemplate] {
        program.days.sorted { $0.order < $1.order }
    }

    private var isActive: Bool { profiles.first?.activeProgramID == program.id }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(program.summary)
                    HStack {
                        Label("\(program.durationWeeks) weeks", systemImage: "calendar")
                        Spacer()
                        Label(program.focus, systemImage: "target")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }

            Section("Workout Days") {
                ForEach(sortedDays) { day in
                    NavigationLink {
                        WorkoutDayDetailView(day: day, programName: program.name)
                    } label: {
                        ProgramDayCard(day: day)
                    }
                }
            }
        }
        .navigationTitle(program.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            Button(isActive ? "Active" : "Set Active") {
                setActive()
            }
            .disabled(isActive)
        }
    }

    private func setActive() {
        if let profile = profiles.first {
            profile.activeProgramID = program.id
        } else {
            context.insert(UserProfile(activeProgramID: program.id))
        }
    }
}
