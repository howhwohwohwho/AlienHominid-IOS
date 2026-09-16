import MetalKit

final class TestTextureGenerator {

    private let device: MTLDevice

    init(device: MTLDevice) {
        self.device = device
    }

    func makeTexture() -> MTLTexture? {
        let width = 128
        let height = 128

        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .bgra8Unorm,
            width: width,
            height: height,
            mipmapped: false
        )

        descriptor.usage = [
            .shaderRead,
            .shaderWrite
        ]

        guard let texture = device.makeTexture(
            descriptor: descriptor
        ) else {
            return nil
        }

        var pixels = [UInt8](
            repeating: 0,
            count: width * height * 4
        )

        for y in 0..<height {
            for x in 0..<width {
                let index = (y * width + x) * 4

                pixels[index] = UInt8(x * 2)
                pixels[index + 1] = UInt8(y * 2)
                pixels[index + 2] = 180
                pixels[index + 3] = 255
            }
        }

        texture.replace(
            region: MTLRegionMake2D(
                0,
                0,
                width,
                height
            ),
            mipmapLevel: 0,
            withBytes: pixels,
            bytesPerRow: width * 4
        )

        return texture
    }
}
