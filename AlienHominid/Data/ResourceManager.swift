import Foundation

final class ResourceManager {

    static let shared = ResourceManager()

    private let pakReader = PakReader()
    private let brecReader = BrecReader()
    private let xprReader = XprReader()

    private init() {}

    func loadPAK(_ url: URL) -> [PakReader.Entry] {
        do {
            return try pakReader.read(url: url)
        } catch {
            print("PAK loading failed: \(error)")
            return []
        }
    }

    func loadBREC(
        data: Data,
        sourceName: String
    ) -> BrecReader.BrecFile? {
        do {
            return try brecReader.read(
                data: data,
                sourceName: sourceName
            )
        } catch {
            print("BREC loading failed: \(error)")
            return nil
        }
    }

    func loadXPR(
        data: Data,
        sourceName: String
    ) -> XprReader.XprResource? {
        do {
            return try xprReader.read(
                data: data,
                sourceName: sourceName
            )
        } catch {
            print("XPR loading failed: \(error)")
            return nil
        }
    }
}
