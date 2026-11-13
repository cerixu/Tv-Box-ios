import UIKit

final class TVHomeViewController: UIViewController {
    private var cardViews: [UIView] = []
    private let grid = UIStackView()
    private let heading = UILabel()
    private let detail = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.025, green: 0.035, blue: 0.052, alpha: 1)
        build()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: TVState.didChange, object: nil)
        refresh()
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    private func build() {
        let brand = UILabel()
        brand.text = "iBox"
        brand.font = .systemFont(ofSize: 38, weight: .bold)
        brand.textColor = .white

        heading.text = "Twoje centrum rozrywki"
        heading.font = .systemFont(ofSize: 30, weight: .semibold)
        heading.textColor = .white

        grid.axis = .vertical
        grid.distribution = .fillEqually
        grid.spacing = 16
        let items = TVState.shared.items
        for rowIndex in 0..<2 {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = 16
            for col in 0..<3 {
                let index = rowIndex * 3 + col
                let item = items[index]
                let icon = UIImageView(image: UIImage(systemName: item.symbol))
                icon.tintColor = UIColor(red: 0.48, green: 0.88, blue: 0.80, alpha: 1)
                icon.contentMode = .scaleAspectFit
                icon.widthAnchor.constraint(equalToConstant: 38).isActive = true
                let name = UILabel()
                name.text = item.title
                name.textColor = .white
                name.font = .systemFont(ofSize: 22, weight: .semibold)
                let sub = UILabel()
                sub.text = item.subtitle
                sub.textColor = .lightGray
                sub.font = .systemFont(ofSize: 13)
                let labels = UIStackView(arrangedSubviews: [name, sub])
                labels.axis = .vertical
                labels.spacing = 6
                let content = UIStackView(arrangedSubviews: [icon, labels])
                content.axis = .horizontal
                content.alignment = .center
                content.spacing = 16
                let card = UIView()
                card.backgroundColor = UIColor(white: 0.10, alpha: 1)
                card.layer.cornerRadius = 22
                card.layer.borderWidth = 2
                card.layer.borderColor = UIColor(white: 0.22, alpha: 1).cgColor
                content.translatesAutoresizingMaskIntoConstraints = false
                card.addSubview(content)
                NSLayoutConstraint.activate([
                    content.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
                    content.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
                    content.centerYAnchor.constraint(equalTo: card.centerYAnchor)
                ])
                cardViews.append(card)
                row.addArrangedSubview(card)
            }
            grid.addArrangedSubview(row)
        }

        detail.textColor = .white
        detail.font = .systemFont(ofSize: 22, weight: .medium)
        detail.numberOfLines = 2
        detail.textAlignment = .center

        let footer = UILabel()
        footer.text = "STEROWANIE: iPhone • Dotknij strzałek, OK lub Wstecz"
        footer.textColor = UIColor(white: 0.55, alpha: 1)
        footer.textAlignment = .right
        footer.font = .systemFont(ofSize: 12, weight: .medium)

        let stack = UIStackView(arrangedSubviews: [brand, heading, grid, detail, footer])
        stack.axis = .vertical
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 64),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -64),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            grid.heightAnchor.constraint(equalToConstant: 310)
        ])
    }

    @objc private func refresh() {
        let state = TVState.shared
        heading.text = state.detailOpen ? state.selectedItem.title : "Twoje centrum rozrywki"
        detail.text = state.detailOpen
            ? "Moduł „\(state.selectedItem.title)” przygotujemy w kolejnych etapach. Użyj Wstecz na iPhonie."
            : "Wybierz kategorię na ekranie iPhone'a."
        grid.isHidden = state.detailOpen
        for (index, card) in cardViews.enumerated() {
            let selected = index == state.selectedIndex && !state.detailOpen
            card.layer.borderColor = selected
                ? UIColor(red: 0.48, green: 0.88, blue: 0.80, alpha: 1).cgColor
                : UIColor(white: 0.22, alpha: 1).cgColor
            card.backgroundColor = selected
                ? UIColor(red: 0.10, green: 0.19, blue: 0.18, alpha: 1)
                : UIColor(white: 0.10, alpha: 1)
        }
    }
}
