import GameController

struct MovementInput {
    let x: Float
    let y: Float
}

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

    func movement(
        controller: GCController
    ) -> MovementInput {

        guard let gamepad = controller.extendedGamepad else {
            return MovementInput(x: 0, y: 0)
        }

        let stickX = gamepad.leftThumbstick.xAxis.value
        let stickY = gamepad.leftThumbstick.yAxis.value

        let dpadX = gamepad.dpad.xAxis.value
        let dpadY = gamepad.dpad.yAxis.value

        // Use whichever input has the larger magnitude.
        let x = abs(stickX) > abs(dpadX) ? stickX : dpadX
        let y = abs(stickY) > abs(dpadY) ? stickY : dpadY

        return MovementInput(x: x, y: y)
    }

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
}
