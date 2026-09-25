import SwiftUI
import SwiftData

struct ProgramsListView: View {
    @Query(sort: \WorkoutProgram.createdAt) private var programs: [WorkoutProgram]
    @Query private var profiles: [UserProfile]

    var body: some View {
        List {
            ForEach(programs) { program in
                NavigationLink {
                    ProgramDetailView(program: program)
                } label: {
                    ProgramRow(program: program, isActive: profiles.first?.activeProgramID == program.id)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Programs")
        .overlay {
            if programs.isEmpty {
                EmptyStateView(icon: "calendar", title: "No Programs Yet", message: "Programs you create will show up here.")
            }
        }
    }
}

private struct ProgramRow: View {
    let program: WorkoutProgram
    let isActive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(program.name).font(.headline)
                if isActive {
                    Text("ACTIVE")
                        .font(.caption2.bold())
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(BWSTheme.accent.opacity(0.15))
                        .foregroundStyle(BWSTheme.accent)
                        .clipShape(Capsule())
                }
            }
            Text(program.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            Text("\(program.durationWeeks) weeks · \(program.days.count) days/week · \(program.focus)")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}
