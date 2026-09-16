import MetalKit

final class SpriteRenderer {

    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private let samplerState: MTLSamplerState

    init?(device: MTLDevice) {
        guard let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary()
        else {
            return nil
        }

        self.device = device
        self.commandQueue = commandQueue

        guard let vertexFunction = library.makeFunction(
                  name: "spriteVertex"
              ),
              let fragmentFunction = library.makeFunction(
                  name: "spriteFragment"
              )
        else {
            return nil
        }

        let descriptor = MTLRenderPipelineDescriptor()

        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        do {
            pipelineState = try device.makeRenderPipelineState(
                descriptor: descriptor
            )
        } catch {
            print("Sprite pipeline creation failed: \(error)")
            return nil
        }

        let samplerDescriptor = MTLSamplerDescriptor()

        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        samplerDescriptor.sAddressMode = .clampToEdge
        samplerDescriptor.tAddressMode = .clampToEdge

        guard let sampler = device.makeSamplerState(
            descriptor: samplerDescriptor
        ) else {
            return nil
        }

        samplerState = sampler
    }

    func draw(
        texture: MTLTexture,
        in view: MTKView
    ) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeRenderCommandEncoder(
                  descriptor: descriptor
              )
        else {
            return
        }

        let vertices: [Float] = [
            -1.0, -1.0, 0.0, 1.0,
             1.0, -1.0, 1.0, 1.0,
            -1.0,  1.0, 0.0, 0.0,

             1.0, -1.0, 1.0, 1.0,
             1.0,  1.0, 1.0, 0.0,
            -1.0,  1.0, 0.0, 0.0
        ]

        let buffer = device.makeBuffer(
            bytes: vertices,
            length: vertices.count * MemoryLayout<Float>.size,
            options: []
        )

        encoder.setRenderPipelineState(pipelineState)

        if let buffer {
            encoder.setVertexBuffer(
                buffer,
                offset: 0,
                index: 0
            )
        }

        encoder.setFragmentTexture(
            texture,
            index: 0
        )

        encoder.setFragmentSamplerState(
            samplerState,
            index: 0
        )

        encoder.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: 6
        )

        encoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
