import Foundation
import GameController

final class ControllerManager {

    private(set) var connectedController: GCController?

    let mapping = ControllerMapping()

    var input = ControllerInput()

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

        GCController.startWirelessControllerDiscovery()

        if let controller = GCController.controllers().first {
            connectedController = controller
        }
    }

    func stop() {
        NotificationCenter.default.removeObserver(self)
        connectedController = nil
    }

    func update() {
        guard let controller = connectedController else {
            input = ControllerInput()
            return
        }

        let movement = mapping.movement(controller: controller)

        input.moveX = movement.x
        input.moveY = movement.y

        input.jump = mapping.buttonPressed(
            .jump,
            controller: controller
        )

        input.shoot = mapping.buttonPressed(
            .shoot,
            controller: controller
        )

        input.melee = mapping.buttonPressed(
            .melee,
            controller: controller
        )

        input.enterVehicle = mapping.buttonPressed(
            .enterVehicle,
            controller: controller
        )

        input.throwGrenade = mapping.buttonPressed(
            .throwGrenade,
            controller: controller
        )

        input.rollRight = mapping.buttonPressed(
            .rollRight,
            controller: controller
        )

        input.rollLeft = mapping.buttonPressed(
            .rollLeft,
            controller: controller
        )

        input.pause = mapping.buttonPressed(
            .pause,
            controller: controller
        )
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
            input = ControllerInput()
        }
    }

    deinit {
        stop()
    }
}
