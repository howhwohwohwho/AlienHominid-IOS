import Foundation

final class ResourceCache {

    static let shared = ResourceCache()

    private var dataCache: [String: Data] = [:]

    private init() {}

    func store(
        _ data: Data,
        for key: String
    ) {
        dataCache[key] = data
    }

    func data(
        for key: String
    ) -> Data? {
        return dataCache[key]
    }

    func contains(
        key: String
    ) -> Bool {
        return dataCache[key] != nil
    }

    func remove(
        key: String
    ) {
        dataCache.removeValue(forKey: key)
    }

    func removeAll() {
        dataCache.removeAll()
    }

    var count: Int {
        return dataCache.count
    }
}
