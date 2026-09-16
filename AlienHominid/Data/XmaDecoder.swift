import Foundation
import AVFoundation

final class XmaDecoder {

    enum XmaError: Error {
        case fileNotFound
        case invalidData
        case unsupportedFormat
        case decodingFailed
    }

    func decode(url: URL) throws -> AVAudioPCMBuffer {

        guard FileManager.default.fileExists(
            atPath: url.path
        ) else {
            throw XmaError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        guard !data.isEmpty else {
            throw XmaError.invalidData
        }

        /*
         XMA is an Xbox 360 audio format.

         iOS does not natively open Xbox 360 XMA files through
         AVAudioFile, so the actual XMA -> PCM decoder will be
         implemented here later.

         For now, keep the original XMA bytes intact and fail
         explicitly instead of treating them as another format.
        */

        throw XmaError.unsupportedFormat
    }
}
