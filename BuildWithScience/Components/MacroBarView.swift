import SwiftUI

struct MacroBarView: View {
    let label: String
    let current: Double
    let goal: Double
    let tint: Color

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(current / goal, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption.bold())
                Spacer()
                Text("\(Int(current))g / \(Int(goal))g")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(tint.opacity(0.15))
                    Capsule().fill(tint)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 8)
        }
    }
}
