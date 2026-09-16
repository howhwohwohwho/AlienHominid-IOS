import Foundation

final class PakReader {

    struct Entry {
        let name: String
        let compressedSize: UInt32
        let uncompressedSize: UInt32
        let data: Data
    }

    enum PakError: Error {
        case fileNotFound
        case notZipBasedPak
        case invalidZip
        case unsupportedCompression
    }

    func read(url: URL) throws -> [Entry] {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw PakError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        // ZIP files begin with PK 03 04.
        guard data.count >= 4 else {
            throw PakError.invalidZip
        }

        let signature = data.prefix(4)

        guard signature == Data([0x50, 0x4B, 0x03, 0x04]) else {
            throw PakError.notZipBasedPak
        }

        /*
         The PAK files in this project use a ZIP-based container.

         ZIP parsing will be expanded here to support:
         - stored files
         - deflate-compressed files
         - directory entries
         - central-directory metadata
        */

        print("ZIP-based PAK detected: \(url.lastPathComponent)")
        print("Size: \(data.count) bytes")

        return []
    }
}
