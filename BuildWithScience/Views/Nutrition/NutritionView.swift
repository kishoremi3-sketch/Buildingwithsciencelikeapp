import SwiftUI
import SwiftData

struct NutritionView: View {
    @Query private var allEntries: [FoodEntry]
    @Query private var profiles: [UserProfile]
    @Environment(\.modelContext) private var context

    @State private var selectedDate = Date.now
    @State private var showAddEntry = false

    private var profile: UserProfile? { profiles.first }

    private var todaysEntries: [FoodEntry] {
        allEntries.filter { $0.date.isSameDay(as: selectedDate) }
            .sorted { $0.date < $1.date }
    }

    private var totals: (calories: Int, protein: Double, carbs: Double, fat: Double) {
        todaysEntries.reduce((0, 0.0, 0.0, 0.0)) { partial, entry in
            (partial.0 + entry.calories, partial.1 + entry.proteinG, partial.2 + entry.carbsG, partial.3 + entry.fatG)
        }
    }

    private let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                summaryCard

                ForEach(mealTypes, id: \.self) { meal in
                    let entries = todaysEntries.filter { $0.mealType == meal }
                    if !entries.isEmpty {
                        mealSection(title: meal, entries: entries)
                    }
                }

                if todaysEntries.isEmpty {
                    EmptyStateView(icon: "camera.fill", title: "No Meals Logged", message: "Tap + to snap a photo of your food and log it.")
                        .padding(.top, 40)
                }
            }
            .padding()
        }
        .background(BWSTheme.screenBackground)
        .navigationTitle("Nutrition")
        .toolbar {
            Button {
                showAddEntry = true
            } label: {
                Image(systemName: "plus.circle.fill")
            }
        }
        .sheet(isPresented: $showAddEntry) {
            AddFoodEntryView(date: selectedDate)
        }
    }

    private var summaryCard: some View {
        let goal = profile?.dailyCalorieGoal ?? 2400
        return VStack(spacing: 16) {
            ZStack {
                RingProgressView(progress: Double(totals.calories) / Double(max(goal, 1)))
                    .frame(width: 130, height: 130)
                VStack {
                    Text("\(totals.calories)")
                        .font(.title.bold())
                    Text("of \(goal) kcal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(spacing: 10) {
                MacroBarView(label: "Protein", current: totals.protein, goal: profile?.proteinGoalG ?? 180, tint: .red)
                MacroBarView(label: "Carbs", current: totals.carbs, goal: profile?.carbsGoalG ?? 250, tint: .orange)
                MacroBarView(label: "Fat", current: totals.fat, goal: profile?.fatGoalG ?? 70, tint: .yellow)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(BWSTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func mealSection(title: String, entries: [FoodEntry]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            ForEach(entries) { entry in
                FoodEntryRow(entry: entry)
                    .contextMenu {
                        Button(role: .destructive) {
                            context.delete(entry)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
    }
}
