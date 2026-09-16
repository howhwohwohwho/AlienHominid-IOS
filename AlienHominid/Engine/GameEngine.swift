import Foundation

final class GameEngine {

    enum State {
        case loading
        case ready
        case running
        case paused
    }

    private(set) var state: State = .loading

    private let dataImporter = GameDataImporter.shared

    private(set) var dataResult:
        GameDataImporter.ImportResult?

   func start() {
    state = .ready
    print("Alien Hominid engine ready.")
}

        dataResult = dataImporter.scanGameData()

        if dataResult?.success == true {
            state = .ready
        } else {
            state = .ready
            print("Game data is not installed yet.")
        }
    }

    func update(deltaTime: TimeInterval) {
        guard state == .running else {
            return
        }

        // Actual game simulation will be added here.
        _ = deltaTime
    }

    func pause() {
        guard state == .running else {
            return
        }

        state = .paused
    }

    func resume() {
        guard state == .paused || state == .ready else {
            return
        }

        state = .running
    }
}
