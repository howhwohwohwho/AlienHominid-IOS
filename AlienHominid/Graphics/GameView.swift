import UIKit

final class GameView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black
        isOpaque = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
