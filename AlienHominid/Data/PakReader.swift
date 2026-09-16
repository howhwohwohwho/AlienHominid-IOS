import Foundation
import Compression

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
        case decompressionFailed
    }

    func read(url: URL) throws -> [Entry] {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw PakError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        guard data.count >= 4 else {
            throw PakError.invalidZip
        }

        guard data.prefix(4) == Data([
            0x50, 0x4B, 0x03, 0x04
        ]) else {
            throw PakError.notZipBasedPak
        }

        return try readLocalEntries(from: data)
    }

    private func readLocalEntries(
        from data: Data
    ) throws -> [Entry] {

        var entries: [Entry] = []
        var offset = 0

        while offset + 30 <= data.count {

            let signature = readUInt32(
                data,
                offset: offset
            )

            guard signature == 0x04034B50 else {
                break
            }

            let compression = readUInt16(
                data,
                offset: offset + 8
            )

            let compressedSize = readUInt32(
                data,
                offset: offset + 18
            )

            let uncompressedSize = readUInt32(
                data,
                offset: offset + 22
            )

            let fileNameLength = Int(
                readUInt16(
                    data,
                    offset: offset + 26
                )
            )

            let extraLength = Int(
                readUInt16(
                    data,
                    offset: offset + 28
                )
            )

            let headerEnd =
                offset +
                30 +
                fileNameLength +
                extraLength

            guard headerEnd <= data.count else {
                throw PakError.invalidZip
            }

            let nameData = data.subdata(
                in: (offset + 30)..<(offset + 30 + fileNameLength)
            )

            let name = String(
                data: nameData,
                encoding: .utf8
            ) ?? "unknown"

            let dataStart = headerEnd
            let dataEnd =
                dataStart + Int(compressedSize)

            guard dataEnd <= data.count else {
                throw PakError.invalidZip
            }

            let compressedData = data.subdata(
                in: dataStart..<dataEnd
            )

            let fileData: Data

            switch compression {

            case 0:
                fileData = compressedData

            case 8:
                fileData = try decompressDeflate(
                    compressedData,
                    expectedSize: Int(uncompressedSize)
                )

            default:
                throw PakError.unsupportedCompression
            }

            entries.append(
                Entry(
                    name: name,
                    compressedSize: compressedSize,
                    uncompressedSize: uncompressedSize,
                    data: fileData
                )
            )

            offset = dataEnd
        }

        return entries
    }

    private func decompressDeflate(
        _ data: Data,
        expectedSize: Int
    ) throws -> Data {

        var destination = Data(
            count: max(expectedSize, data.count * 4)
        )

        // Store the capacity BEFORE entering the mutable access.
        // This avoids Swift's overlapping-access error.
        let destinationCapacity = destination.count

        let decodedSize = destination.withUnsafeMutableBytes {
            destinationBuffer -> Int in

            data.withUnsafeBytes {
                sourceBuffer -> Int in

                guard let destinationPointer =
                        destinationBuffer.bindMemory(
                            to: UInt8.self
                        ).baseAddress,
                      let sourcePointer =
                        sourceBuffer.bindMemory(
                            to: UInt8.self
                        ).baseAddress
                else {
                    return 0
                }

                return compression_decode_buffer(
                    destinationPointer,
                    destinationCapacity,
                    sourcePointer,
                    data.count,
                    nil,
                    COMPRESSION_ZLIB
                )
            }
        }

        guard decodedSize > 0 else {
            throw PakError.decompressionFailed
        }

        destination.count = decodedSize

        return destination
    }

    private func readUInt16(
        _ data: Data,
        offset: Int
    ) -> UInt16 {

        let b0 = UInt16(data[offset])
        let b1 = UInt16(data[offset + 1])

        return b0 | (b1 << 8)
    }

    private func readUInt32(
        _ data: Data,
        offset: Int
    ) -> UInt32 {

        let b0 = UInt32(data[offset])
        let b1 = UInt32(data[offset + 1])
        let b2 = UInt32(data[offset + 2])
        let b3 = UInt32(data[offset + 3])

        return b0
            | (b1 << 8)
            | (b2 << 16)
            | (b3 << 24)
    }
}
