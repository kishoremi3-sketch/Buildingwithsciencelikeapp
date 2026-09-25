import SwiftUI
import SwiftData

struct SetRowView: View {
    @Bindable var set: LoggedSet
    let targetReps: String

    var body: some View {
        HStack(spacing: 12) {
            Text(set.isWarmup ? "W" : "\(set.setNumber)")
                .font(.subheadline.bold())
                .frame(width: 28, height: 28)
                .background(set.isCompleted ? BWSTheme.accent.opacity(0.2) : Color(.tertiarySystemFill))
                .clipShape(Circle())

            TextField("lb", value: $set.weight, format: .number)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 70)

            TextField(targetReps, value: $set.reps, format: .number)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 60)

            Spacer()

            Button {
                set.isCompleted.toggle()
            } label: {
                Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(set.isCompleted ? BWSTheme.accent : .secondary)
            }
            .buttonStyle(.plain)
        }
    }
}
