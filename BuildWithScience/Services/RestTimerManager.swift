import Foundation
import UIKit

@MainActor
final class RestTimerManager: ObservableObject {
    @Published var secondsRemaining: Int = 0
    @Published var totalSeconds: Int = 0
    @Published var isRunning: Bool = false

    private var timer: Timer?

    func start(seconds: Int) {
        totalSeconds = seconds
        secondsRemaining = seconds
        isRunning = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    private func tick() {
        guard secondsRemaining > 0 else {
            finish()
            return
        }
        secondsRemaining -= 1
        if secondsRemaining == 0 {
            finish()
        }
    }

    func addTime(_ seconds: Int) {
        secondsRemaining = max(0, secondsRemaining + seconds)
        totalSeconds = max(totalSeconds, secondsRemaining)
    }

    func skip() {
        finish()
    }

    private func finish() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        secondsRemaining = 0
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(totalSeconds - secondsRemaining) / Double(totalSeconds)
    }
}
