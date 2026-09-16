import Foundation

final class BrecReader {

    struct BrecFile {
        let data: Data
        let sourceName: String
    }

    enum BrecError: Error {
        case emptyData
        case invalidData
        case unsupportedFormat
    }

    func read(
        data: Data,
        sourceName: String
    ) throws -> BrecFile {

        guard !data.isEmpty else {
            throw BrecError.emptyData
        }

        /*
         BREC is an Xbox 360 game-resource format.

         We do not assume undocumented offsets or structures here.
         The exact BREC layout will be implemented once the format
         used by this game is identified.

         Keeping the original bytes lets later resource readers
         process the data without modifying the source file.
        */

        return BrecFile(
            data: data,
            sourceName: sourceName
        )
    }
}
