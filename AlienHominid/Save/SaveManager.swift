import Foundation

final class SaveManager {

    static let shared = SaveManager()

    private let fileManager = FileManager.default

    private var saveURL: URL {
        let documents = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documents
            .appendingPathComponent("AlienHominid", isDirectory: true)
            .appendingPathComponent("save.json")
    }

    private init() {}

    func save(_ data: SaveData) {
        do {
            let folder = saveURL.deletingLastPathComponent()

            if !fileManager.fileExists(atPath: folder.path) {
                try fileManager.createDirectory(
                    at: folder,
                    withIntermediateDirectories: true
                )
            }

            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: saveURL)
        } catch {
            print("Save failed: \(error)")
        }
    }

    func load() -> SaveData {
        do {
            let data = try Data(contentsOf: saveURL)

            return try JSONDecoder().decode(
                SaveData.self,
                from: data
            )
        } catch {
            return SaveData()
        }
    }
}

struct SaveData: Codable {

    var currentLevel: Int = 0
    var score: Int = 0
    var lives: Int = 3
}
