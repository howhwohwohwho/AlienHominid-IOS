import MetalKit

final class MetalRenderer: NSObject, MTKViewDelegate {

    private let device: MTLDevice
    private let spriteRenderer: SpriteRenderer
    private let testTextureGenerator: TestTextureGenerator

    private var testSprite: Sprite?

    init?(view: MTKView) {
        guard let device = view.device,
              let spriteRenderer = SpriteRenderer(device: device)
        else {
            return nil
        }

        self.device = device
        self.spriteRenderer = spriteRenderer
        self.testTextureGenerator = TestTextureGenerator(
            device: device
        )

        super.init()

        view.delegate = self

        createTestSprite()
    }

    private func createTestSprite() {
        guard let texture = testTextureGenerator.makeTexture() else {
            print("Could not create test texture.")
            return
        }

        testSprite = Sprite(
            texture: texture,
            position: SIMD2<Float>(0, 0),
            size: SIMD2<Float>(0.5, 0.5)
        )
    }

    func draw(in view: MTKView) {
        guard let sprite = testSprite else {
            return
        }

        spriteRenderer.draw(
            sprite: sprite,
            in: view
        )
    }

    func mtkView(
        _ view: MTKView,
        drawableSizeWillChange size: CGSize
    ) {
        // Rendering resolution will be handled here later.
    }
}
