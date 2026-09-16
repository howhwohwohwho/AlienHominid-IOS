import GameController

enum GameButton {
    case jump
    case shoot
    case melee
    case enterVehicle
    case throwGrenade
    case rollRight
    case rollLeft
    case pause
}

final class ControllerMapping {

    func buttonPressed(
        _ button: GameButton,
        controller: GCController
    ) -> Bool {

        guard let gamepad = controller.extendedGamepad else {
            return false
        }

        switch button {

        case .jump:
            return gamepad.buttonA.isPressed

        case .shoot:
            return gamepad.buttonX.isPressed

        case .melee:
            return gamepad.buttonX.isPressed

        case .enterVehicle:
            return gamepad.buttonY.isPressed

        case .throwGrenade:
            return gamepad.buttonB.isPressed

        case .rollRight:
            return gamepad.rightTrigger.isPressed

        case .rollLeft:
            return gamepad.leftTrigger.isPressed

        case .pause:
            return gamepad.buttonMenu.isPressed
        }
    }

    func movement(
        controller: GCController
    ) -> (x: Float, y: Float) {

        guard let gamepad = controller.extendedGamepad else {
            return (0, 0)
        }

        return (
            x: gamepad.leftThumbstick.xAxis.value,
            y: gamepad.leftThumbstick.yAxis.value
        )
    }
}
