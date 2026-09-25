import SwiftUI
import SwiftData

@main
struct BuildWithScienceApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([
            Exercise.self,
            WorkoutProgram.self,
            WorkoutDayTemplate.self,
            ProgramExerciseTemplate.self,
            WorkoutSession.self,
            LoggedExercise.self,
            LoggedSet.self,
            BodyMetricEntry.self,
            ProgressPhoto.self,
            FoodEntry.self,
            UserProfile.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        SeedData.seedIfNeeded(context: container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(container)
    }
}
