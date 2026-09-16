import Foundation

final class XprReader {

    struct XprResource {
        let data: Data
        let sourceName: String
    }

    enum XprError: Error {
        case emptyData
        case invalidData
        case unsupportedFormat
    }

    func read(
        data: Data,
        sourceName: String
    ) throws -> XprResource {

        guard !data.isEmpty else {
            throw XprError.emptyData
        }

        /*
         XPR files contain Xbox 360 resource data.

         We keep the original bytes intact here.
         The actual XPR header, resource table, texture formats,
         and GPU resource layout will be implemented in the
         renderer/resource layer after the format is identified.
        */

        return XprResource(
            data: data,
            sourceName: sourceName
        )
    }
}
