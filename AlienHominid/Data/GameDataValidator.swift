import Foundation

final class GameDataValidator {

    struct ValidationResult {
        let isValid: Bool
        let filesFound: Int
        let pakFiles: Int
        let xprFiles: Int
        let xmaFiles: Int
        let warnings: [String]
    }

    func validate(
        files: [GameFile]
    ) -> ValidationResult {

        let pakCount = files.filter {
            $0.fileExtension == "pak"
        }.count

        let xprCount = files.filter {
            $0.fileExtension == "xpr"
        }.count

        let xmaCount = files.filter {
            $0.fileExtension == "xma"
        }.count

        var warnings: [String] = []

        if pakCount == 0 {
            warnings.append("No PAK files found.")
        }

        if xprCount == 0 {
            warnings.append("No XPR files found.")
        }

        if xmaCount == 0 {
            warnings.append("No XMA audio files found.")
        }

        let valid = !files.isEmpty

        return ValidationResult(
            isValid: valid,
            filesFound: files.count,
            pakFiles: pakCount,
            xprFiles: xprCount,
            xmaFiles: xmaCount,
            warnings: warnings
        )
    }
}
