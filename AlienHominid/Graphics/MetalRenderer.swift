import MetalKit

final class MetalRenderer: NSObject, MTKViewDelegate {

    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue

    let textureManager: TextureManager
    private let spriteRenderer: SpriteRenderer

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

        super.init()

        view.delegate = self
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

        commandBuffer.present(drawable)
        commandBuffer.commit()

        // Sprite drawing will be enabled once a test texture
        // has been loaded into the application bundle.
        _ = testSprite
    }

    func setTestSprite(_ sprite: Sprite) {
        testSprite = sprite
    }

    func drawTexture(
        _ texture: MTLTexture,
        in view: MTKView
    ) {
        let sprite = Sprite(
            texture: texture,
            position: SIMD2<Float>(0, 0),
            size: SIMD2<Float>(0.5, 0.5)
        )

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
        // Rendering resolution will be handled here later.
    }
}
