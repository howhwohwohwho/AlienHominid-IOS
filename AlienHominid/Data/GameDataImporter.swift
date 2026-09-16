import Foundation

final class GameDataImporter {

    static let shared = GameDataImporter()

    private let dataManager = GameDataManager.shared
    private let validator = GameDataValidator()

    private init() {}

    struct ImportResult {
        let success: Bool
        let filesFound: Int
        let pakFiles: Int
        let xprFiles: Int
        let xmaFiles: Int
        let warnings: [String]
    }

    func scanGameData() -> ImportResult {

        let files = dataManager.files()

        let validation = validator.validate(
            files: files
        )

        return ImportResult(
            success: validation.isValid,
            filesFound: validation.filesFound,
            pakFiles: validation.pakFiles,
            xprFiles: validation.xprFiles,
            xmaFiles: validation.xmaFiles,
            warnings: validation.warnings
        )
    }

    func findPAKFiles() -> [GameFile] {
        return dataManager.files().filter {
            $0.fileExtension == "pak"
        }
    }

    func findXPRFiles() -> [GameFile] {
        return dataManager.files().filter {
            $0.fileExtension == "xpr"
        }
    }

    func findXMAFiles() -> [GameFile] {
        return dataManager.files().filter {
            $0.fileExtension == "xma"
        }
    }
}
