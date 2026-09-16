import Foundation
import GameController

final class ControllerManager {

    private(set) var connectedController: GCController?

    func start() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controllerConnected),
            name: GCController.didConnectNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controllerDisconnected),
            name: GCController.didDisconnectNotification,
            object: nil
        )

        GCController.startWirelessControllerDiscovery {}

        if let controller = GCController.controllers().first {
            connectedController = controller
        }
    }

    func stop() {
        NotificationCenter.default.removeObserver(self)
        connectedController = nil
    }

    @objc private func controllerConnected(
        _ notification: Notification
    ) {
        guard let controller = notification.object as? GCController else {
            return
        }

        connectedController = controller
    }

    @objc private func controllerDisconnected(
        _ notification: Notification
    ) {
        guard let controller = notification.object as? GCController else {
            return
        }

        if connectedController === controller {
            connectedController = nil
        }
    }

    deinit {
        stop()
    }
}
