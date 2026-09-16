import UIKit

final class GameViewController: UIViewController {

    private var gameView: GameView!
    private let engine = GameEngine()
    private let controllerManager = ControllerManager()
    private var gameLoop: GameLoop!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        setupGameView()
        setupGameLoop()
    }

    private func setupGameView() {
        gameView = GameView()

        gameView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(gameView)

        NSLayoutConstraint.activate([
            gameView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            gameView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            gameView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            gameView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    private func setupGameLoop() {
        gameLoop = GameLoop(
            engine: engine,
            controllerManager: controllerManager
        )

        gameLoop.start()
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    deinit {
        gameLoop?.stop()
    }
}
