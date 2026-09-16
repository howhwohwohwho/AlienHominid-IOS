import Foundation

final class GameEngine {

    enum State {
        case loading
        case ready
        case running
        case paused
    }

    private(set) var state: State = .loading

    func start() {
        state = .ready
    }

    func update(deltaTime: TimeInterval) {
        guard state == .running else {
            return
        }

        // Actual game logic will be added here.
    }

    func pause() {
        state = .paused
    }

    func resume() {
        state = .running
    }
}
