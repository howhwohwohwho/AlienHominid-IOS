import Foundation
import QuartzCore

final class GameLoop {

    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0

    var update: ((TimeInterval) -> Void)?

    func start() {
        stop()

        lastTimestamp = 0

        let link = CADisplayLink(
            target: self,
            selector: #selector(tick)
        )

        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func tick(_ link: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = link.timestamp
            return
        }

        let deltaTime = link.timestamp - lastTimestamp
        lastTimestamp = link.timestamp

        update?(deltaTime)
    }

    deinit {
        stop()
    }
}
