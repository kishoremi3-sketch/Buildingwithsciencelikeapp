import Foundation
import SwiftData

enum SeedData {
    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Exercise>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0
        guard existingCount == 0 else { return }

        makeExercises().forEach { context.insert($0) }

        let program = makeProgram()
        context.insert(program)

        let profile = UserProfile(activeProgramID: program.id)
        context.insert(profile)

        seedSampleHistory(context: context)

        try? context.save()
    }

    private static func makeExercises() -> [Exercise] {
        [
            Exercise(name: "Barbell Bench Press", primaryMuscle: "Chest", secondaryMuscles: ["Triceps", "Shoulders"], equipment: "Barbell", instructions: "Lie on a flat bench, lower the bar to mid-chest with control, and press up until your arms are extended without locking out aggressively."),
            Exercise(name: "Incline Dumbbell Press", primaryMuscle: "Chest", secondaryMuscles: ["Shoulders", "Triceps"], equipment: "Dumbbells", instructions: "On a 30-45° incline bench, press dumbbells up and slightly inward, keeping elbows at roughly 45° from your torso."),
            Exercise(name: "Cable Fly", primaryMuscle: "Chest", secondaryMuscles: [], equipment: "Cable Machine", instructions: "With a slight bend in the elbows, sweep the handles together in front of your chest, squeezing at the peak."),
            Exercise(name: "Push-Up", primaryMuscle: "Chest", secondaryMuscles: ["Triceps", "Core"], equipment: "Bodyweight", instructions: "Keep a straight line from head to heels, lower until your chest nears the floor, then press back up."),
            Exercise(name: "Deadlift", primaryMuscle: "Back", secondaryMuscles: ["Hamstrings", "Glutes"], equipment: "Barbell", instructions: "Hinge at the hips with a neutral spine, drive through the floor, and stand tall while keeping the bar close to your body."),
            Exercise(name: "Pull-Up", primaryMuscle: "Back", secondaryMuscles: ["Biceps"], equipment: "Pull-Up Bar", instructions: "Hang with arms extended, pull your chin over the bar leading with your elbows, then lower under control."),
            Exercise(name: "Barbell Row", primaryMuscle: "Back", secondaryMuscles: ["Biceps"], equipment: "Barbell", instructions: "Hinge forward with a flat back, row the bar to your lower ribs, and squeeze your shoulder blades together."),
            Exercise(name: "Lat Pulldown", primaryMuscle: "Back", secondaryMuscles: ["Biceps"], equipment: "Cable Machine", instructions: "Pull the bar to your upper chest while leaning back slightly, driving your elbows down and back."),
            Exercise(name: "Seated Cable Row", primaryMuscle: "Back", secondaryMuscles: ["Biceps"], equipment: "Cable Machine", instructions: "Keep your torso upright as you row the handle to your abdomen, squeezing your back at the finish."),
            Exercise(name: "Overhead Press", primaryMuscle: "Shoulders", secondaryMuscles: ["Triceps"], equipment: "Barbell", instructions: "Press the bar overhead in a straight line, finishing with your head pushed slightly through your arms."),
            Exercise(name: "Lateral Raise", primaryMuscle: "Shoulders", secondaryMuscles: [], equipment: "Dumbbells", instructions: "Raise dumbbells out to your sides to shoulder height with a slight elbow bend, leading with your elbows."),
            Exercise(name: "Face Pull", primaryMuscle: "Shoulders", secondaryMuscles: ["Back"], equipment: "Cable Machine", instructions: "Pull the rope toward your face, flaring your elbows high and externally rotating at the end range."),
            Exercise(name: "Barbell Curl", primaryMuscle: "Biceps", secondaryMuscles: [], equipment: "Barbell", instructions: "Curl the bar up while keeping your elbows pinned to your sides, avoiding momentum from your hips."),
            Exercise(name: "Hammer Curl", primaryMuscle: "Biceps", secondaryMuscles: ["Forearms"], equipment: "Dumbbells", instructions: "Curl with a neutral grip, keeping elbows stationary and controlling the descent."),
            Exercise(name: "Tricep Pushdown", primaryMuscle: "Triceps", secondaryMuscles: [], equipment: "Cable Machine", instructions: "Keep elbows pinned to your sides as you extend the handle down until your arms are straight."),
            Exercise(name: "Skull Crusher", primaryMuscle: "Triceps", secondaryMuscles: [], equipment: "EZ Bar", instructions: "Lower the bar toward your forehead by bending only at the elbows, then extend back up."),
            Exercise(name: "Close-Grip Bench Press", primaryMuscle: "Triceps", secondaryMuscles: ["Chest"], equipment: "Barbell", instructions: "Use a shoulder-width grip and keep elbows tucked as you press, emphasizing triceps drive."),
            Exercise(name: "Back Squat", primaryMuscle: "Quads", secondaryMuscles: ["Glutes", "Hamstrings"], equipment: "Barbell", instructions: "Brace your core, squat until your hip crease passes your knee, and drive up through your whole foot."),
            Exercise(name: "Leg Press", primaryMuscle: "Quads", secondaryMuscles: ["Glutes"], equipment: "Leg Press Machine", instructions: "Lower the platform until your knees reach about 90°, then press through your heels."),
            Exercise(name: "Walking Lunge", primaryMuscle: "Quads", secondaryMuscles: ["Glutes"], equipment: "Dumbbells", instructions: "Step forward into a lunge, lower your back knee toward the floor, then drive up into the next step."),
            Exercise(name: "Romanian Deadlift", primaryMuscle: "Hamstrings", secondaryMuscles: ["Glutes"], equipment: "Barbell", instructions: "Push your hips back with a slight knee bend, lowering the bar along your legs until you feel a hamstring stretch."),
            Exercise(name: "Leg Curl", primaryMuscle: "Hamstrings", secondaryMuscles: [], equipment: "Leg Curl Machine", instructions: "Curl the pad toward your glutes, controlling the eccentric on the way back."),
            Exercise(name: "Hip Thrust", primaryMuscle: "Glutes", secondaryMuscles: ["Hamstrings"], equipment: "Barbell", instructions: "With your shoulders on a bench, drive your hips up until your torso is parallel to the floor, squeezing your glutes hard."),
            Exercise(name: "Standing Calf Raise", primaryMuscle: "Calves", secondaryMuscles: [], equipment: "Calf Raise Machine", instructions: "Rise onto your toes as high as possible, pause, then lower under control for a full stretch."),
            Exercise(name: "Hanging Leg Raise", primaryMuscle: "Core", secondaryMuscles: [], equipment: "Pull-Up Bar", instructions: "Hang from the bar and raise your legs to hip height or higher without swinging."),
            Exercise(name: "Cable Crunch", primaryMuscle: "Core", secondaryMuscles: [], equipment: "Cable Machine", instructions: "Kneel below the cable, crunch your torso down by flexing your spine rather than pulling with your arms."),
            Exercise(name: "Plank", primaryMuscle: "Core", secondaryMuscles: [], equipment: "Bodyweight", instructions: "Hold a straight line from head to heels, bracing your core and glutes throughout the hold.")
        ]
    }

    private static func makeProgram() -> WorkoutProgram {
        let day1 = WorkoutDayTemplate(name: "Upper Body – Strength", order: 0, exercises: [
            ProgramExerciseTemplate(exerciseName: "Barbell Bench Press", targetSets: 4, targetRepsLow: 4, targetRepsHigh: 6, restSeconds: 150, order: 0),
            ProgramExerciseTemplate(exerciseName: "Barbell Row", targetSets: 4, targetRepsLow: 6, targetRepsHigh: 8, restSeconds: 120, order: 1),
            ProgramExerciseTemplate(exerciseName: "Overhead Press", targetSets: 3, targetRepsLow: 6, targetRepsHigh: 8, restSeconds: 120, order: 2),
            ProgramExerciseTemplate(exerciseName: "Pull-Up", targetSets: 3, targetRepsLow: 6, targetRepsHigh: 10, restSeconds: 120, order: 3),
            ProgramExerciseTemplate(exerciseName: "Barbell Curl", targetSets: 3, targetRepsLow: 8, targetRepsHigh: 10, restSeconds: 75, order: 4),
            ProgramExerciseTemplate(exerciseName: "Tricep Pushdown", targetSets: 3, targetRepsLow: 8, targetRepsHigh: 10, restSeconds: 75, order: 5)
        ])
        let day2 = WorkoutDayTemplate(name: "Lower Body – Strength", order: 1, exercises: [
            ProgramExerciseTemplate(exerciseName: "Back Squat", targetSets: 4, targetRepsLow: 4, targetRepsHigh: 6, restSeconds: 150, order: 0),
            ProgramExerciseTemplate(exerciseName: "Romanian Deadlift", targetSets: 3, targetRepsLow: 6, targetRepsHigh: 8, restSeconds: 120, order: 1),
            ProgramExerciseTemplate(exerciseName: "Leg Press", targetSets: 3, targetRepsLow: 8, targetRepsHigh: 10, restSeconds: 120, order: 2),
            ProgramExerciseTemplate(exerciseName: "Hip Thrust", targetSets: 3, targetRepsLow: 8, targetRepsHigh: 10, restSeconds: 100, order: 3),
            ProgramExerciseTemplate(exerciseName: "Standing Calf Raise", targetSets: 4, targetRepsLow: 10, targetRepsHigh: 15, restSeconds: 60, order: 4),
            ProgramExerciseTemplate(exerciseName: "Hanging Leg Raise", targetSets: 3, targetRepsLow: 10, targetRepsHigh: 15, restSeconds: 60, order: 5)
        ])
        let day3 = WorkoutDayTemplate(name: "Upper Body – Hypertrophy", order: 2, exercises: [
            ProgramExerciseTemplate(exerciseName: "Incline Dumbbell Press", targetSets: 4, targetRepsLow: 8, targetRepsHigh: 12, restSeconds: 90, order: 0),
            ProgramExerciseTemplate(exerciseName: "Lat Pulldown", targetSets: 4, targetRepsLow: 8, targetRepsHigh: 12, restSeconds: 90, order: 1),
            ProgramExerciseTemplate(exerciseName: "Lateral Raise", targetSets: 3, targetRepsLow: 12, targetRepsHigh: 15, restSeconds: 60, order: 2),
            ProgramExerciseTemplate(exerciseName: "Seated Cable Row", targetSets: 3, targetRepsLow: 10, targetRepsHigh: 12, restSeconds: 90, order: 3),
            ProgramExerciseTemplate(exerciseName: "Cable Fly", targetSets: 3, targetRepsLow: 12, targetRepsHigh: 15, restSeconds: 60, order: 4),
            ProgramExerciseTemplate(exerciseName: "Hammer Curl", targetSets: 3, targetRepsLow: 10, targetRepsHigh: 12, restSeconds: 60, order: 5),
            ProgramExerciseTemplate(exerciseName: "Skull Crusher", targetSets: 3, targetRepsLow: 10, targetRepsHigh: 12, restSeconds: 60, order: 6)
        ])
        let day4 = WorkoutDayTemplate(name: "Lower Body – Hypertrophy", order: 3, exercises: [
            ProgramExerciseTemplate(exerciseName: "Walking Lunge", targetSets: 3, targetRepsLow: 10, targetRepsHigh: 12, restSeconds: 90, order: 0),
            ProgramExerciseTemplate(exerciseName: "Leg Curl", targetSets: 4, targetRepsLow: 10, targetRepsHigh: 12, restSeconds: 75, order: 1),
            ProgramExerciseTemplate(exerciseName: "Leg Press", targetSets: 3, targetRepsLow: 12, targetRepsHigh: 15, restSeconds: 90, order: 2),
            ProgramExerciseTemplate(exerciseName: "Hip Thrust", targetSets: 3, targetRepsLow: 10, targetRepsHigh: 12, restSeconds: 90, order: 3),
            ProgramExerciseTemplate(exerciseName: "Standing Calf Raise", targetSets: 4, targetRepsLow: 12, targetRepsHigh: 15, restSeconds: 60, order: 4),
            ProgramExerciseTemplate(exerciseName: "Cable Crunch", targetSets: 3, targetRepsLow: 12, targetRepsHigh: 15, restSeconds: 60, order: 5),
            ProgramExerciseTemplate(exerciseName: "Plank", targetSets: 3, targetRepsLow: 30, targetRepsHigh: 60, restSeconds: 45, order: 6)
        ])

        return WorkoutProgram(
            name: "Foundations Hypertrophy",
            summary: "A 4-day upper/lower split built to build strength and size with evidence-based volume and progression.",
            durationWeeks: 8,
            focus: "Upper/Lower Split",
            days: [day1, day2, day3, day4]
        )
    }

    private static func seedSampleHistory(context: ModelContext) {
        let calendar = Calendar.current
        for offset in stride(from: 27, through: 1, by: -2) {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: .now) else { continue }
            let weight = 82.5 - Double(27 - offset) * 0.06
            context.insert(BodyMetricEntry(date: date, weightKg: weight, bodyFatPercent: nil, notes: ""))
        }
    }
}
