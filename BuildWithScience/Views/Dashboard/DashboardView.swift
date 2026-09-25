import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var profiles: [UserProfile]
    @Query(sort: \WorkoutProgram.createdAt, order: .reverse) private var programs: [WorkoutProgram]
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]
    @Query(sort: \BodyMetricEntry.date, order: .reverse) private var weightEntries: [BodyMetricEntry]
    @Query private var foodEntries: [FoodEntry]

    @State private var selectedDate = Date.now

    private var profile: UserProfile? { profiles.first }

    private var activeProgram: WorkoutProgram? {
        guard let id = profile?.activeProgramID else { return programs.first }
        return programs.first { $0.id == id } ?? programs.first
    }

    private var todaysCalories: Int {
        foodEntries
            .filter { Calendar.current.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.calories }
    }

    private var currentWeekday: Int {
        Calendar.current.component(.weekday, from: .now)
    }

    private var todaysDay: WorkoutDayTemplate? {
        guard let program = activeProgram, !program.days.isEmpty else { return nil }
        let sorted = program.days.sorted { $0.order < $1.order }
        let index = (currentWeekday - 2 + 7) % sorted.count
        return sorted[safe: index]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                CalendarStripView(
                    selectedDate: $selectedDate,
                    completedDates: Set(sessions.filter(\.isCompleted).map { $0.date.startOfDay })
                )

                if let day = todaysDay, let program = activeProgram {
                    TodayWorkoutCard(program: program, day: day)
                } else {
                    EmptyStateView(icon: "calendar.badge.plus", title: "No Active Program", message: "Start a program from the Programs tab to see today's workout here.")
                }

                statsGrid

                if !sessions.isEmpty {
                    recentActivity
                }
            }
            .padding()
        }
        .background(BWSTheme.screenBackground)
        .navigationTitle("Home")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Date.now.formatted(.dateTime.weekday(.wide).month().day()))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Welcome back\(profile.map { ", \($0.name)" } ?? "")")
                .font(.largeTitle.bold())
        }
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(title: "Calories Today", value: "\(todaysCalories) kcal", icon: "flame.fill", tint: .orange)
            StatCard(title: "Current Weight", value: weightEntries.first.map { String(format: "%.1f kg", $0.weightKg) } ?? "--", icon: "scalemass.fill", tint: BWSTheme.accent)
            StatCard(title: "Workouts Logged", value: "\(sessions.filter(\.isCompleted).count)", icon: "checkmark.seal.fill", tint: BWSTheme.primary)
            StatCard(title: "Program", value: activeProgram?.name ?? "None", icon: "list.bullet.rectangle", tint: .purple)
        }
    }

    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Activity").font(.headline)
            ForEach(sessions.prefix(3)) { session in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(BWSTheme.accent)
                    VStack(alignment: .leading) {
                        Text(session.dayName).font(.subheadline.bold())
                        Text(session.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(session.durationMinutes) min")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(BWSTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
}

private struct TodayWorkoutCard: View {
    let program: WorkoutProgram
    let day: WorkoutDayTemplate

    var body: some View {
        NavigationLink {
            WorkoutDayDetailView(day: day, programName: program.name)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Today's Workout").font(.caption.bold()).foregroundStyle(.white.opacity(0.8))
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(.white.opacity(0.8))
                }
                Text(day.name)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("\(day.exercises.count) exercises · \(program.name)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(LinearGradient(colors: [BWSTheme.primary, BWSTheme.accent], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}
