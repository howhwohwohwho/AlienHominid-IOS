import Foundation

final class GameDataManager {

    static let shared = GameDataManager()

    private let fileManager = FileManager.default

    private init() {}

    private var gameDataURL: URL {
        let documents = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documents.appendingPathComponent(
            "GameData",
            isDirectory: true
        )
    }

    func prepareGameDataFolder() {
        do {
            if !fileManager.fileExists(atPath: gameDataURL.path) {
                try fileManager.createDirectory(
                    at: gameDataURL,
                    withIntermediateDirectories: true
                )
            }
        } catch {
            print("Could not create game data folder: \(error)")
        }
    }

    func files() -> [GameFile] {
        prepareGameDataFolder()

        do {
            let urls = try fileManager.contentsOfDirectory(
                at: gameDataURL,
                includingPropertiesForKeys: nil
            )

            return urls.map {
                GameFile(url: $0)
            }
        } catch {
            print("Could not read game data folder: \(error)")
            return []
        }
    }

    func hasGameData() -> Bool {
        return !files().isEmpty
    }
}
