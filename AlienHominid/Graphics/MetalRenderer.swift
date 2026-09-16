import MetalKit

final class MetalRenderer: NSObject, MTKViewDelegate {

    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue

    let textureManager: TextureManager
    private let spriteRenderer: SpriteRenderer

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
    }

    func drawTexture(
        _ texture: MTLTexture,
        in view: MTKView
    ) {
        spriteRenderer.draw(
            texture: texture,
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
