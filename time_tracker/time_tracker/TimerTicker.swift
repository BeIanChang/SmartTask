import SwiftUI
import Combine

@MainActor
final class TimerTicker: ObservableObject {
    @Published var now = Date()
    private var timer: Timer?

    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.now = Date()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
