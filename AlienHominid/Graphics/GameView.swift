import MetalKit

final class GameView: MTKView {

    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device.")
        }

        super.init(frame: .zero, device: device)

        framebufferOnly = false
        enableSetNeedsDisplay = false
        isPaused = false
        preferredFramesPerSecond = 60
        colorPixelFormat = .bgra8Unorm
        clearColor = MTLClearColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 1
        )
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
