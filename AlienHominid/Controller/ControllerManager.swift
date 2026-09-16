import Foundation
import GameController

@MainActor
final class ControllerManager {

    private(set) var connectedController: GCController?

    let mapping = ControllerMapping()

    var input = ControllerInput()

    private var connectObserver: NSObjectProtocol?
    private var disconnectObserver: NSObjectProtocol?

    func start() {
        stop()

        connectObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.GCControllerDidConnect,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let controller = notification.object as? GCController else {
                return
            }

            self?.connectedController = controller
        }

        disconnectObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.GCControllerDidDisconnect,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let controller = notification.object as? GCController else {
                return
            }

            guard let self else {
                return
            }

            if self.connectedController === controller {
                self.connectedController = nil
                self.input = ControllerInput()
            }
        }

        if let controller = GCController.controllers().first {
            connectedController = controller
        }

        GCController.startWirelessControllerDiscovery()
    }

    func stop() {
        if let connectObserver {
            NotificationCenter.default.removeObserver(connectObserver)
            self.connectObserver = nil
        }

        if let disconnectObserver {
            NotificationCenter.default.removeObserver(disconnectObserver)
            self.disconnectObserver = nil
        }

        connectedController = nil
        input = ControllerInput()
    }

    func update() {
        guard let controller = connectedController else {
            input = ControllerInput()
            return
        }

        let movement = mapping.movement(
            controller: controller
        )

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

    deinit {
        if let connectObserver {
            NotificationCenter.default.removeObserver(connectObserver)
        }

        if let disconnectObserver {
            NotificationCenter.default.removeObserver(disconnectObserver)
        }
    }
}
