import SwiftUI
import SwiftData

struct ExerciseLibraryView: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]
    @State private var searchText = ""
    @State private var selectedMuscle: MuscleGroup?

    private var filtered: [Exercise] {
        exercises.filter { exercise in
            let matchesSearch = searchText.isEmpty || exercise.name.localizedCaseInsensitiveContains(searchText)
            let matchesMuscle = selectedMuscle == nil || exercise.primaryMuscle == selectedMuscle?.rawValue
            return matchesSearch && matchesMuscle
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(title: "All", isSelected: selectedMuscle == nil) { selectedMuscle = nil }
                    ForEach(MuscleGroup.allCases) { muscle in
                        FilterChip(title: muscle.rawValue, isSelected: selectedMuscle == muscle) {
                            selectedMuscle = selectedMuscle == muscle ? nil : muscle
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }

            List(filtered) { exercise in
                NavigationLink {
                    ExerciseDetailView(exercise: exercise)
                } label: {
                    ExerciseCard(exercise: exercise)
                }
            }
            .listStyle(.plain)
            .overlay {
                if filtered.isEmpty {
                    EmptyStateView(icon: "magnifyingglass", title: "No Exercises Found", message: "Try a different search or filter.")
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search exercises")
        .navigationTitle("Exercise Library")
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? BWSTheme.primary : Color(.tertiarySystemFill))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
