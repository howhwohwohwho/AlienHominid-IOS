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

        if let renderPass = descriptor.colorAttachments[0] {
            renderPass.loadAction = .clear
            renderPass.storeAction = .store
            renderPass.clearColor = MTLClearColor(
                red: 0,
                green: 0,
                blue: 0,
                alpha: 1
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
