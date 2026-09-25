import SwiftUI

struct RestTimerSheet: View {
    @ObservedObject var timer: RestTimerManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text("Rest Timer")
                .font(.headline)
                .foregroundStyle(.secondary)

            ZStack {
                RingProgressView(progress: timer.progress, lineWidth: 16, tint: BWSTheme.primary)
                    .frame(width: 160, height: 160)
                Text(formatted(timer.secondsRemaining))
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }

            HStack(spacing: 20) {
                Button { timer.addTime(-15) } label: {
                    Label("15s", systemImage: "gobackward.15")
                }
                Button { timer.addTime(15) } label: {
                    Label("15s", systemImage: "goforward.15")
                }
            }
            .buttonStyle(.bordered)

            Button("Skip Rest") {
                timer.skip()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(BWSTheme.accent)

            Spacer()
        }
        .padding()
        .onChange(of: timer.secondsRemaining) { _, newValue in
            if newValue == 0 && !timer.isRunning {
                dismiss()
            }
        }
    }

    private func formatted(_ seconds: Int) -> String {
        String(format: "%d:%02d", seconds / 60, seconds % 60)
    }
}
