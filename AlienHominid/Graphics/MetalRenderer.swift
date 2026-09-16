import MetalKit

final class MetalRenderer: NSObject, MTKViewDelegate {

    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue

    init?(view: MTKView) {
        guard let device = view.device,
              let commandQueue = device.makeCommandQueue()
        else {
            return nil
        }

        self.device = device
        self.commandQueue = commandQueue

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

        if let colorAttachment = descriptor.colorAttachments[0] {
            colorAttachment.loadAction = .clear
            colorAttachment.storeAction = .store

            // Temporary background for the renderer.
            colorAttachment.clearColor = MTLClearColor(
                red: 0.05,
                green: 0.05,
                blue: 0.05,
                alpha: 1.0
            )
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
