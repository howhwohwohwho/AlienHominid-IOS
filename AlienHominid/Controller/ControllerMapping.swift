import GameController

enum GameButton {
    case jump
    case attack
    case special
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

        case .attack:
            return gamepad.buttonX.isPressed

        case .special:
            return gamepad.buttonY.isPressed

        case .pause:
            return gamepad.buttonMenu.isPressed
        }
    }
}
