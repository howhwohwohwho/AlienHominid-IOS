import Foundation
import QuartzCore

final class GameLoop {

    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0

    private let engine: GameEngine
    private let controllerManager: ControllerManager

    init(
        engine: GameEngine,
        controllerManager: ControllerManager
    ) {
        self.engine = engine
        self.controllerManager = controllerManager
    }

    func start() {
        stop()

        controllerManager.start()
        engine.start()

        lastTimestamp = 0

        let link = CADisplayLink(
            target: self,
            selector: #selector(tick)
        )

        link.add(
            to: .main,
            forMode: .common
        )

        displayLink = link
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil

        controllerManager.stop()
    }

    @objc private func tick(
        _ link: CADisplayLink
    ) {
        if lastTimestamp == 0 {
            lastTimestamp = link.timestamp
            return
        }

        let deltaTime =
            link.timestamp - lastTimestamp

        lastTimestamp = link.timestamp

        controllerManager.update()

        if controllerManager.input.pause {
            engine.pause()
        }

        engine.update(
            deltaTime: deltaTime
        )
    }

    deinit {
        stop()
    }
}
