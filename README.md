# Build With Science–style Training App

A native SwiftUI iOS app inspired by Jeremy Ethier's "Build With Science" app: structured workout
programs, in-workout set/rep logging with rest timers, an exercise library, body-weight and photo
progress tracking, and a photo-based calorie/macro tracker.

## Requirements

- Xcode 15+ (iOS 17 SDK)
- iOS 17+ simulator or device

## Getting started

Open `BuildWithScience.xcodeproj` in Xcode and run the `BuildWithScience` scheme on an iOS 17+
simulator or device. No backend, API keys, or account setup required — everything is stored
on-device with SwiftData, and the app seeds itself with a sample 4-day "Foundations Hypertrophy"
program and ~26 exercises on first launch.

## Features

- **Dashboard** — today's scheduled workout, a weekly calendar strip, quick stats (calories,
  weight, workouts logged).
- **Programs** — browse workout programs, drill into each day's exercises, and start a session.
- **Active workout logging** — log weight/reps per set, mark sets complete, and get an automatic
  rest-timer sheet (with +/-15s adjustment) between sets.
- **Exercise library** — searchable, filterable by muscle group, with instructions and an
  optional video slot (plays via `AVPlayer`/`VideoPlayer` if an exercise has a video URL; shows a
  placeholder otherwise since no video content is bundled).
- **Nutrition / photo calorie tracker** — snap or pick a food photo, run an on-device estimate via
  Vision's built-in `VNClassifyImageRequest` image classifier matched against a small local
  nutrition table, then review/edit the pre-filled calories and macros before saving. This is a
  general-purpose classifier, not a food-specialized model, so estimates are a starting point, not
  a verified measurement — the UI always surfaces the detected label/confidence and expects the
  user to confirm.
- **Progress tracking** — log body weight over time (chart via Swift Charts) and add
  front/side/back progress photos.

## Project structure

```
BuildWithScience/
  BuildWithScienceApp.swift   # App entry, SwiftData ModelContainer setup
  Models/                     # SwiftData @Model types
  Services/                   # Seed data, rest timer, food-photo estimator, nutrition table
  Components/                 # Reusable small views (cards, bars, rings, theme)
  Views/
    Dashboard/
    Programs/
    Exercises/
    Nutrition/
    Progress/
```

## Known follow-ups

- No app icon artwork is bundled (`AppIcon.appiconset` has an empty 1024×1024 slot) — add real
  icon images before shipping.
- Exercises ship without demo videos; `Exercise.videoURLString` is wired up (`AVPlayer` plays it
  when present) but left `nil` in the seed data.
- This was scaffolded in a Linux container without Xcode/macOS, so the project has not been
  compiled or run in a simulator — open it in Xcode and build to catch any remaining issues.
