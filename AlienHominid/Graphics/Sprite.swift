import MetalKit

struct Sprite {

    var texture: MTLTexture?

    var position: SIMD2<Float>

    var size: SIMD2<Float>

    var rotation: Float = 0

    var visible: Bool = true

    init(
        texture: MTLTexture? = nil,
        position: SIMD2<Float> = SIMD2<Float>(0, 0),
        size: SIMD2<Float> = SIMD2<Float>(1, 1)
    ) {
        self.texture = texture
        self.position = position
        self.size = size
    }
}
