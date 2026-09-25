import SwiftUI
import SwiftData

struct AddWeightEntryView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date.now
    @State private var weight: Double = 80
    @State private var bodyFat: Double = 15
    @State private var trackBodyFat = false
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                Stepper("Weight: \(String(format: "%.1f", weight)) kg", value: $weight, in: 30...250, step: 0.1)

                Toggle("Track Body Fat %", isOn: $trackBodyFat)
                if trackBodyFat {
                    Stepper("Body Fat: \(String(format: "%.1f", bodyFat))%", value: $bodyFat, in: 3...60, step: 0.1)
                }

                TextField("Notes", text: $notes, axis: .vertical)
            }
            .navigationTitle("Log Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }

    private func save() {
        let entry = BodyMetricEntry(date: date, weightKg: weight, bodyFatPercent: trackBodyFat ? bodyFat : nil, notes: notes)
        context.insert(entry)
        try? context.save()
        dismiss()
    }
}
