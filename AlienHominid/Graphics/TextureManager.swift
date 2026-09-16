import Foundation
import MetalKit

final class TextureManager {

    private let device: MTLDevice
    private let loader: MTKTextureLoader

    private var textures: [String: MTLTexture] = [:]

    init(device: MTLDevice) {
        self.device = device
        self.loader = MTKTextureLoader(device: device)
    }

    func loadPNG(
        url: URL,
        key: String
    ) -> MTLTexture? {

        if let cached = textures[key] {
            return cached
        }

        do {
            let texture = try loader.newTexture(
                URL: url,
                options: [
                    MTKTextureLoader.Option.SRGB:
                        false
                ]
            )

            textures[key] = texture
            return texture

        } catch {
            print(
                "Texture loading failed for \(url.lastPathComponent): \(error)"
            )
            return nil
        }
    }

    func texture(
        for key: String
    ) -> MTLTexture? {
        return textures[key]
    }

    func remove(
        key: String
    ) {
        textures.removeValue(forKey: key)
    }

    func removeAll() {
        textures.removeAll()
    }
}
