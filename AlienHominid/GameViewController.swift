import UIKit

final class GameViewController: UIViewController {

    private var gameView: GameView!
    private let gameEngine = GameEngine()

    override func loadView() {
        gameView = GameView(frame: .zero)
        view = gameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        gameEngine.start()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        gameEngine.resume()
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
}
