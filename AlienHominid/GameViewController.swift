import UIKit

final class GameViewController: UIViewController {

    private let titleLabel = UILabel()
    private let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "Alien Hominid"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center

        statusLabel.text = "Native iOS port"
        statusLabel.textColor = .lightGray
        statusLabel.font = UIFont.systemFont(ofSize: 18)
        statusLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            statusLabel
        ])

        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
