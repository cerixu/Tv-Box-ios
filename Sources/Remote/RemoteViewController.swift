import UIKit

final class RemoteViewController: UIViewController {
    private var displayRegistration: UISceneAccessoryRegistration?
    private let status = UILabel()
    override var canBecomeFirstResponder: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.035, green: 0.047, blue: 0.067, alpha: 1)
        buildUI()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: TVState.didChange, object: nil)
        registerExternalDisplay()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
        refresh()
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    private func buildUI() {
        let title = UILabel()
        title.text = "iBox Remote"
        title.font = .systemFont(ofSize: 32, weight: .bold)
        title.textColor = .white

        let subtitle = UILabel()
        subtitle.text = "Połącz iPhone'a z Samsungiem przez AirPlay. Ten ekran jest Twoim pilotem."
        subtitle.textColor = .lightGray
        subtitle.numberOfLines = 0
        subtitle.font = .systemFont(ofSize: 15)

        status.textColor = UIColor(red: 0.48, green: 0.88, blue: 0.80, alpha: 1)
        status.numberOfLines = 0
        status.font = .systemFont(ofSize: 13, weight: .medium)

        let up = button("▲") { TVState.shared.move(0, -1) }
        let left = button("◀") { TVState.shared.move(-1, 0) }
        let ok = button("OK") { TVState.shared.select() }
        let right = button("▶") { TVState.shared.move(1, 0) }
        let down = button("▼") { TVState.shared.move(0, 1) }
        let back = button("WSTECZ") { TVState.shared.back() }
        let home = button("HOME") { TVState.shared.home() }

        let row1 = UIStackView(arrangedSubviews: [UIView(), up, UIView()])
        let row2 = UIStackView(arrangedSubviews: [left, ok, right])
        let row3 = UIStackView(arrangedSubviews: [UIView(), down, UIView()])
        let actions = UIStackView(arrangedSubviews: [row1, row2, row3])
        actions.axis = .vertical
        actions.spacing = 12
        [row1, row2, row3].forEach { $0.axis = .horizontal; $0.distribution = .fillEqually; $0.spacing = 12 }
        [up, left, ok, right, down].forEach { $0.heightAnchor.constraint(equalToConstant: 64).isActive = true }

        let footer = UIStackView(arrangedSubviews: [back, home])
        footer.axis = .horizontal
        footer.distribution = .fillEqually
        footer.spacing = 12

        let stack = UIStackView(arrangedSubviews: [title, subtitle, status, actions, footer])
        stack.axis = .vertical
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func button(_ title: String, action: @escaping () -> Void) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = UIColor(white: 0.15, alpha: 1)
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        let button = UIButton(configuration: config)
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return button
    }

    private func registerExternalDisplay() {
        let config = UISceneConfiguration()
        config.delegateClass = ExternalDisplaySceneDelegate.self
        let accessory = UISceneAccessory.externalNonInteractive(sceneConfiguration: config)
        displayRegistration = registerSceneAccessory(accessory)
    }

    @objc private func refresh() {
        let available = displayRegistration?.isAvailable == true
        status.text = available
            ? "Ekran zewnętrzny dostępny. Wybierz kafelek poniżej."
            : "Czekam na ekran AirPlay. W Centrum sterowania wybierz Klonowanie ekranu → Samsung."
    }

    override var keyCommands: [UIKeyCommand]? {
        [
            UIKeyCommand(input: UIKeyCommand.inputUpArrow, action: #selector(up)),
            UIKeyCommand(input: UIKeyCommand.inputDownArrow, action: #selector(down)),
            UIKeyCommand(input: UIKeyCommand.inputLeftArrow, action: #selector(left)),
            UIKeyCommand(input: UIKeyCommand.inputRightArrow, action: #selector(right)),
            UIKeyCommand(input: "\r", action: #selector(select)),
            UIKeyCommand(input: UIKeyCommand.inputEscape, action: #selector(back)),
            UIKeyCommand(input: "h", action: #selector(home))
        ]
    }
    @objc private func up() { TVState.shared.move(0, -1) }
    @objc private func down() { TVState.shared.move(0, 1) }
    @objc private func left() { TVState.shared.move(-1, 0) }
    @objc private func right() { TVState.shared.move(1, 0) }
    @objc private func select() { TVState.shared.select() }
    @objc private func back() { TVState.shared.back() }
    @objc private func home() { TVState.shared.home() }
}
