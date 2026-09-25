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
            Exercise(name: "Barbell Bench Press", primaryMuscle: "Chest", secondaryMuscles: ["Triceps", "Shoulders"], equipment: "Barbell",
                instructions: "Lie on a flat bench with eyes under the bar, feet flat on the floor, and a grip just wider than shoulder width.",
                steps: ["Unrack the bar and hold it directly over your shoulders with arms locked out.", "Lower the bar under control to mid-chest, tucking your elbows to about 45°.", "Press the bar back up in a straight line until your arms are extended.", "Keep your shoulder blades pinched and feet driving into the floor throughout."],
                coachingTip: "Don't let the bar drift toward your neck or flare your elbows to 90° — both strain the shoulders.",
                videoURLString: "https://www.youtube.com/watch?v=vthMCtgVtFw", videoSourceName: "ATHLEAN-X"),
            Exercise(name: "Incline Dumbbell Press", primaryMuscle: "Chest", secondaryMuscles: ["Shoulders", "Triceps"], equipment: "Dumbbells",
                instructions: "Set a bench to a 30-45° incline and sit with a dumbbell in each hand resting on your thighs.",
                steps: ["Kick the dumbbells up to shoulder height one at a time as you lie back.", "Press both dumbbells up and slightly inward until your arms are extended.", "Lower them under control until your upper arms are just below parallel.", "Keep your elbows at roughly 45° from your torso, not flared to the sides."],
                coachingTip: "A steeper incline shifts work to the front shoulders — 30-45° keeps the emphasis on the upper chest.",
                videoURLString: "https://www.muscleandstrength.com/exercises/incline-dumbbell-bench-press.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Cable Fly", primaryMuscle: "Chest", secondaryMuscles: [], equipment: "Cable Machine",
                instructions: "Set both pulleys to chest height and stand centered between them.",
                steps: ["Grab a handle in each hand and step forward until you feel tension in your chest.", "With a slight, fixed bend in your elbows, sweep the handles in front of your chest.", "Squeeze your chest hard at the point where your hands meet.", "Return under control to the starting stretch position."],
                coachingTip: "Keep the elbow bend constant throughout — bending more at the top turns it into a press, not a fly.",
                videoURLString: "https://www.muscleandstrength.com/exercises/flat-bench-cable-flys.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Push-Up", primaryMuscle: "Chest", secondaryMuscles: ["Triceps", "Core"], equipment: "Bodyweight",
                instructions: "Start in a high plank with hands slightly wider than shoulder-width and your body in a straight line.",
                steps: ["Brace your core and squeeze your glutes to lock your body in a straight line.", "Lower your chest toward the floor, keeping elbows at about 45°.", "Press back up to full arm extension without letting your hips sag or pike."],
                coachingTip: "If your hips sag, regress to an incline push-up (hands on a bench) until your core is strong enough.",
                videoURLString: "https://www.youtube.com/watch?v=-Mbr55h3BeQ", videoSourceName: "ATHLEAN-X"),
            Exercise(name: "Deadlift", primaryMuscle: "Back", secondaryMuscles: ["Hamstrings", "Glutes"], equipment: "Barbell",
                instructions: "Stand with feet hip-width apart, the bar over your mid-foot, and grip it just outside your shins.",
                steps: ["Bend your knees until your shins touch the bar, keeping your chest up and back flat.", "Take the slack out of the bar and brace your core hard.", "Drive through the floor, keeping the bar close to your legs as you stand tall.", "Lock out by squeezing your glutes — don't hyperextend your lower back.", "Reverse the motion to lower the bar, hinging at the hips first."],
                coachingTip: "The bar should travel in a straight vertical line — if it drifts forward, you'll round your lower back.",
                videoURLString: "https://www.muscleandstrength.com/exercises/deadlifts.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Pull-Up", primaryMuscle: "Back", secondaryMuscles: ["Biceps"], equipment: "Pull-Up Bar",
                instructions: "Hang from the bar with an overhand grip just outside shoulder width, arms fully extended.",
                steps: ["Engage your shoulder blades by pulling them down and back before you move.", "Pull your chin over the bar by driving your elbows down toward your hips.", "Pause briefly at the top with your chest up.", "Lower yourself under control back to a full hang."],
                coachingTip: "Avoid kipping or swinging early on — a slow, controlled rep builds far more back strength.",
                videoURLString: "https://www.youtube.com/watch?v=sIvJTfGxdFo", videoSourceName: "ATHLEAN-X"),
            Exercise(name: "Barbell Row", primaryMuscle: "Back", secondaryMuscles: ["Biceps"], equipment: "Barbell",
                instructions: "Hinge forward from the hips to about a 45° torso angle, holding the bar with an overhand grip.",
                steps: ["Let the bar hang at arm's length without rounding your lower back.", "Row the bar up to your lower ribs, driving your elbows straight back.", "Squeeze your shoulder blades together at the top.", "Lower the bar under control back to a full stretch."],
                coachingTip: "Keep your torso angle fixed — using your hips to heave the bar up turns this into a bad deadlift.",
                videoURLString: "https://www.youtube.com/watch?v=HW1tV_ilN68", videoSourceName: "ATHLEAN-X"),
            Exercise(name: "Lat Pulldown", primaryMuscle: "Back", secondaryMuscles: ["Biceps"], equipment: "Cable Machine",
                instructions: "Sit at the machine and grab the bar with a wide, overhand grip, thighs locked under the pad.",
                steps: ["Lean back slightly and pull the bar down to your upper chest.", "Drive your elbows down and back, not just bending your arms.", "Squeeze your lats hard at the bottom of the movement.", "Let the bar rise under control back to a full stretch."],
                coachingTip: "Avoid yanking the bar down with momentum — a controlled tempo keeps the tension on your back, not your arms.",
                videoURLString: "https://www.youtube.com/watch?v=OcFCHdQHjVU", videoSourceName: "ATHLEAN-X"),
            Exercise(name: "Seated Cable Row", primaryMuscle: "Back", secondaryMuscles: ["Biceps"], equipment: "Cable Machine",
                instructions: "Sit with knees slightly bent, feet on the platform, and grab the handle with arms extended.",
                steps: ["Sit up tall with a neutral spine before you start pulling.", "Row the handle to your abdomen, leading with your elbows.", "Squeeze your shoulder blades together without leaning back excessively.", "Extend your arms back out under control, letting your lats stretch."],
                coachingTip: "Keep your torso mostly still — rocking back and forth just adds momentum, not muscle work.",
                videoURLString: "https://www.muscleandstrength.com/exercises/seated-row.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Overhead Press", primaryMuscle: "Shoulders", secondaryMuscles: ["Triceps"], equipment: "Barbell",
                instructions: "Hold the bar at shoulder height with hands just outside shoulder-width, elbows slightly in front of the bar.",
                steps: ["Brace your core and squeeze your glutes to keep your ribs stacked over your hips.", "Press the bar straight up, moving your head back slightly to let it pass.", "Push your head through once the bar clears your face, finishing overhead.", "Lower the bar back to shoulder height under control."],
                coachingTip: "Avoid excessive lower-back arch — a hard brace protects your spine as the weight goes up.",
                videoURLString: "https://www.muscleandstrength.com/exercises/military-press.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Lateral Raise", primaryMuscle: "Shoulders", secondaryMuscles: [], equipment: "Dumbbells",
                instructions: "Stand tall holding a dumbbell in each hand at your sides, palms facing your body.",
                steps: ["With a slight bend in your elbows, raise both arms out to your sides.", "Lead with your elbows, lifting to about shoulder height.", "Pause briefly at the top without shrugging your traps up.", "Lower the dumbbells slowly back to your sides."],
                coachingTip: "Lighter weight with strict form beats heavier weight that turns into a shrug-and-swing.",
                videoURLString: "https://www.muscleandstrength.com/exercises/dumbbell-lateral-raise.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Face Pull", primaryMuscle: "Shoulders", secondaryMuscles: ["Back"], equipment: "Cable Machine",
                instructions: "Set a cable at upper-chest to head height and grab the rope with both hands, palms in.",
                steps: ["Step back until there's tension, arms extended in front of you.", "Pull the rope toward your face, splitting your hands apart.", "Flare your elbows high and rotate your hands so thumbs point back.", "Return slowly to the stretched starting position."],
                coachingTip: "Aim for the rope ending beside your ears, not your chest — that's what drives the external rotation.",
                videoURLString: "https://www.muscleandstrength.com/exercises/cable-face-pull", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Barbell Curl", primaryMuscle: "Biceps", secondaryMuscles: [], equipment: "Barbell",
                instructions: "Stand tall holding the bar with an underhand, shoulder-width grip, arms fully extended.",
                steps: ["Keep your elbows pinned to your sides for the whole rep.", "Curl the bar up by bending only at the elbow.", "Squeeze your biceps at the top without swinging your torso.", "Lower the bar slowly back to full extension."],
                coachingTip: "If you need to lean back to move the weight, it's too heavy — reset with a lighter load.",
                videoURLString: "https://www.muscleandstrength.com/exercises/standing-barbell-curl.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Hammer Curl", primaryMuscle: "Biceps", secondaryMuscles: ["Forearms"], equipment: "Dumbbells",
                instructions: "Stand holding a dumbbell in each hand at your sides with a neutral, palms-in grip.",
                steps: ["Keep your upper arms and elbows stationary against your sides.", "Curl both dumbbells up while keeping your wrists neutral.", "Squeeze at the top, then lower under control."],
                coachingTip: "This grip hits the brachialis and forearms more than a regular curl — great for grip strength too.",
                videoURLString: "https://www.muscleandstrength.com/exercises/standing-hammer-curl.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Tricep Pushdown", primaryMuscle: "Triceps", secondaryMuscles: [], equipment: "Cable Machine",
                instructions: "Stand facing a cable stack with a bar or rope attachment set above head height.",
                steps: ["Pin your elbows to your sides and take a slight forward lean.", "Extend your arms down until they're straight, without moving your elbows.", "Squeeze your triceps hard at full extension.", "Let the handle rise back under control to about 90° at the elbow."],
                coachingTip: "If your elbows drift forward as you push down, you're using your shoulders to cheat the weight.",
                videoURLString: "https://www.muscleandstrength.com/exercises/tricep-extension.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Skull Crusher", primaryMuscle: "Triceps", secondaryMuscles: [], equipment: "EZ Bar",
                instructions: "Lie on a bench holding an EZ bar with a shoulder-width grip, arms extended over your chest.",
                steps: ["Keeping your upper arms still, bend only at the elbows to lower the bar.", "Lower it toward your forehead or just behind your head.", "Extend your arms back to the starting position, driving through your triceps."],
                coachingTip: "Keep your elbows pointed at the ceiling — letting them flare out shifts stress onto your shoulders.",
                videoURLString: "https://www.youtube.com/watch?v=gXbSA9EKUtA", videoSourceName: "ATHLEAN-X"),
            Exercise(name: "Close-Grip Bench Press", primaryMuscle: "Triceps", secondaryMuscles: ["Chest"], equipment: "Barbell",
                instructions: "Lie on a flat bench and grip the bar with hands about shoulder-width apart.",
                steps: ["Unrack the bar and hold it over your chest with arms extended.", "Lower the bar to your lower chest, keeping your elbows tucked close to your body.", "Press back up, focusing on driving through your triceps."],
                coachingTip: "A grip much narrower than shoulder width adds wrist strain without extra triceps benefit.",
                videoURLString: "https://www.youtube.com/watch?v=a2G3IdaTcPU", videoSourceName: "Scott Viala"),
            Exercise(name: "Back Squat", primaryMuscle: "Quads", secondaryMuscles: ["Glutes", "Hamstrings"], equipment: "Barbell",
                instructions: "Set the bar across your upper back, feet shoulder-width apart, toes turned slightly out.",
                steps: ["Brace your core and unrack the bar, taking a step back to your stance.", "Break at the hips and knees together, sitting down and back.", "Descend until your hip crease passes below your knee.", "Drive up through your whole foot, keeping your chest up."],
                coachingTip: "Keep your knees tracking over your toes — letting them cave inward is a common fault under fatigue.",
                videoURLString: "https://www.muscleandstrength.com/exercises/squat.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Leg Press", primaryMuscle: "Quads", secondaryMuscles: ["Glutes"], equipment: "Leg Press Machine",
                instructions: "Sit in the machine with feet shoulder-width on the platform, lower back flat against the pad.",
                steps: ["Unrack the sled and let your knees bend toward your chest under control.", "Lower until your knees reach about 90°, without your lower back rounding off the pad.", "Press through your heels to extend your legs, without locking your knees hard."],
                coachingTip: "Never let your lower back round at the bottom — reduce the range of motion if that happens.",
                videoURLString: "https://www.muscleandstrength.com/exercises/45-degree-leg-press.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Walking Lunge", primaryMuscle: "Quads", secondaryMuscles: ["Glutes"], equipment: "Dumbbells",
                instructions: "Stand tall holding a dumbbell in each hand at your sides.",
                steps: ["Step forward into a long stride and lower your back knee toward the floor.", "Keep your front shin roughly vertical at the bottom of the lunge.", "Drive through your front foot to stand up and step into the next lunge.", "Alternate legs as you walk forward."],
                coachingTip: "A longer step emphasizes your glutes; a shorter step shifts more work to your quads.",
                videoURLString: "https://www.muscleandstrength.com/exercises/dumbbell-walking-lunge.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Romanian Deadlift", primaryMuscle: "Hamstrings", secondaryMuscles: ["Glutes"], equipment: "Barbell",
                instructions: "Stand holding the bar at hip height with a shoulder-width, overhand grip.",
                steps: ["Push your hips straight back while keeping a slight bend in your knees.", "Lower the bar along your legs, keeping it close to your body.", "Go as low as you can while keeping your back flat — usually mid-shin.", "Drive your hips forward to return to standing, squeezing your glutes."],
                coachingTip: "This is a hip-hinge, not a squat — your knees should barely bend beyond the initial set.",
                videoURLString: "https://www.youtube.com/watch?v=_oyxCn2iSjU", videoSourceName: "Jeff Nippard"),
            Exercise(name: "Leg Curl", primaryMuscle: "Hamstrings", secondaryMuscles: [], equipment: "Leg Curl Machine",
                instructions: "Lie face down on the machine with the pad positioned just above your heels.",
                steps: ["Grip the handles and keep your hips pressed into the bench.", "Curl the pad toward your glutes by contracting your hamstrings.", "Squeeze briefly at the top of the movement.", "Lower back down slowly, resisting the weight the whole way."],
                coachingTip: "Don't let your hips pop up off the bench to help lift the weight — that's your lower back taking over.",
                videoURLString: "https://www.muscleandstrength.com/exercises/leg-curl.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Hip Thrust", primaryMuscle: "Glutes", secondaryMuscles: ["Hamstrings"], equipment: "Barbell",
                instructions: "Sit on the floor with your upper back against a bench, a barbell over your hips.",
                steps: ["Plant your feet flat, roughly under your knees, hip-width apart.", "Drive through your heels to lift your hips until your torso is parallel to the floor.", "Squeeze your glutes hard at the top without overextending your lower back.", "Lower your hips back down under control, just short of touching the floor."],
                coachingTip: "Tuck your chin slightly at the top — looking up encourages an arched, lower-back-dominant finish.",
                videoURLString: "https://www.youtube.com/watch?v=qFxTNOiQIAU", videoSourceName: "Bret Contreras"),
            Exercise(name: "Standing Calf Raise", primaryMuscle: "Calves", secondaryMuscles: [], equipment: "Calf Raise Machine",
                instructions: "Stand on the machine's platform with the balls of your feet on the edge, heels hanging off.",
                steps: ["Let your heels drop below the platform for a full stretch.", "Rise up onto your toes as high as you can.", "Pause briefly at the top, then lower back down under control."],
                coachingTip: "Rushing the reps skips the stretch at the bottom, which is where a lot of the growth stimulus comes from.",
                videoURLString: "https://www.muscleandstrength.com/exercises/standing-calf-raise.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Hanging Leg Raise", primaryMuscle: "Core", secondaryMuscles: [], equipment: "Pull-Up Bar",
                instructions: "Hang from a pull-up bar with a shoulder-width grip, legs extended below you.",
                steps: ["Brace your core and avoid swinging before you start.", "Raise your legs by curling your pelvis up, not just swinging from your hips.", "Bring your legs to at least hip height, or higher if you can control it.", "Lower your legs back down slowly without using momentum."],
                coachingTip: "Bend your knees to make it easier while you build core strength for the full straight-leg version.",
                videoURLString: "https://www.muscleandstrength.com/exercises/hanging-leg-raise.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Cable Crunch", primaryMuscle: "Core", secondaryMuscles: [], equipment: "Cable Machine",
                instructions: "Kneel below a cable stack, holding the rope attachment beside your head.",
                steps: ["Set your hips back slightly with your thighs roughly vertical.", "Crunch your torso down by flexing your spine, not by pulling with your arms.", "Bring your elbows toward your thighs, exhaling as you crunch.", "Extend back up under control, keeping tension on your abs."],
                coachingTip: "Your hips should stay mostly still — this is a spinal flexion movement, not a hip-hinge.",
                videoURLString: "https://www.muscleandstrength.com/exercises/cable-crunch.html", videoSourceName: "Muscle & Strength"),
            Exercise(name: "Plank", primaryMuscle: "Core", secondaryMuscles: [], equipment: "Bodyweight",
                instructions: "Prop yourself up on your forearms and toes, elbows directly under your shoulders.",
                steps: ["Squeeze your glutes and brace your core to flatten your lower back.", "Keep a straight line from your head to your heels — no sagging or raised hips.", "Breathe steadily and hold the position for time."],
                coachingTip: "If your lower back sags, drop to your knees or shorten the hold rather than let your form break down.",
                videoURLString: "https://www.muscleandstrength.com/exercises/hover.html", videoSourceName: "Muscle & Strength")
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
