import Foundation

struct GameFile {

    let url: URL

    var name: String {
        url.lastPathComponent
    }

    var fileExtension: String {
        url.pathExtension.lowercased()
    }

    var size: Int64 {
        do {
            let attributes = try FileManager.default.attributesOfItem(
                atPath: url.path
            )

            return attributes[.size] as? Int64 ?? 0
        } catch {
            return 0
        }
    }
}
