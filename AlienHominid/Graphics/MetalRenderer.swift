import MetalKit

final class MetalRenderer: NSObject, MTKViewDelegate {

    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue

    let textureManager: TextureManager
    private let spriteRenderer: SpriteRenderer
    private let testTextureGenerator: TestTextureGenerator

    private var testSprite: Sprite?

    init?(view: MTKView) {
        guard let device = view.device,
              let commandQueue = device.makeCommandQueue(),
              let spriteRenderer = SpriteRenderer(device: device)
        else {
            return nil
        }

        self.device = device
        self.commandQueue = commandQueue
        self.textureManager = TextureManager(device: device)
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
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer()
        else {
            return
        }

        if let attachment = descriptor.colorAttachments[0] {
            attachment.loadAction = .clear
            attachment.storeAction = .store

            attachment.clearColor = MTLClearColor(
                red: 0.05,
                green: 0.05,
                blue: 0.05,
                alpha: 1.0
            )
        }

        if let sprite = testSprite,
           let texture = sprite.texture {

            spriteRenderer.draw(
                sprite: Sprite(
                    texture: texture,
                    position: sprite.position,
                    size: sprite.size,
                    rotation: sprite.rotation,
                    visible: sprite.visible
                ),
                in: view
            )

            return
        }

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func mtkView(
        _ view: MTKView,
        drawableSizeWillChange size: CGSize
    ) {
        // Rendering resolution will be handled here later.
    }
}
