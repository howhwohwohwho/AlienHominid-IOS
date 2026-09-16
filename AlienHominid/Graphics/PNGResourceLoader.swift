import Foundation
import MetalKit

final class PNGResourceLoader {

    private let textureManager: TextureManager

    init(device: MTLDevice) {
        textureManager = TextureManager(device: device)
    }

    func load(
        url: URL,
        key: String
    ) -> MTLTexture? {

        guard url.pathExtension.lowercased() == "png" else {
            print("Not a PNG file: \(url.lastPathComponent)")
            return nil
        }

        return textureManager.loadPNG(
            url: url,
            key: key
        )
    }

    func texture(
        for key: String
    ) -> MTLTexture? {
        return textureManager.texture(
            for: key
        )
    }

    func remove(
        key: String
    ) {
        textureManager.remove(
            key: key
        )
    }

    func removeAll() {
        textureManager.removeAll()
    }
}
