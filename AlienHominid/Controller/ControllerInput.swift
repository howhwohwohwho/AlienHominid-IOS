import Foundation

struct ControllerInput {

    // Movement
    var moveX: Float = 0
    var moveY: Float = 0

    // Face buttons
    var jump = false
    var shoot = false
    var melee = false
    var enterVehicle = false
    var throwGrenade = false

    // Triggers
    var rollRight = false
    var rollLeft = false

    // System
    var pause = false
}
