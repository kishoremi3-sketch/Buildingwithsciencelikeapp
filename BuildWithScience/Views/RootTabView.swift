import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack { DashboardView() }
                .tabItem { Label("Dashboard", systemImage: "house.fill") }

            NavigationStack { ProgramsListView() }
                .tabItem { Label("Programs", systemImage: "calendar") }

            NavigationStack { ExerciseLibraryView() }
                .tabItem { Label("Exercises", systemImage: "figure.strengthtraining.traditional") }

            NavigationStack { NutritionView() }
                .tabItem { Label("Nutrition", systemImage: "fork.knife") }

            NavigationStack { ProgressTrackerView() }
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }
        }
        .tint(BWSTheme.primary)
    }
}
