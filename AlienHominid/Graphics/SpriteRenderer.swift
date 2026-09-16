import MetalKit

final class SpriteRenderer {

    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue

    init?(device: MTLDevice) {
        guard let commandQueue = device.makeCommandQueue() else {
            return nil
        }

        self.device = device
        self.commandQueue = commandQueue
    }

    func draw(
        texture: MTLTexture,
        in view: MTKView
    ) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer()
        else {
            return
        }

        if let attachment = descriptor.colorAttachments[0] {
            attachment.loadAction = .clear
            attachment.storeAction = .store
        }

        // Sprite pipeline will be implemented here.
        // The texture is intentionally not drawn yet.

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
