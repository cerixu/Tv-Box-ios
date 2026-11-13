import Foundation

@MainActor
final class TVState {
    static let shared = TVState()
    static let didChange = Notification.Name("iBox.TVState.didChange")

    let items: [(title: String, subtitle: String, symbol: String)] = [
        ("Filmy", "Twoja biblioteka", "film"),
        ("Seriale", "Kontynuuj oglądanie", "play.rectangle"),
        ("YouTube", "Wideo online", "play.tv"),
        ("Muzyka", "Albumy i playlisty", "music.note"),
        ("Zdjęcia", "Twoje wspomnienia", "photo"),
        ("Aplikacje", "Centrum aplikacji", "square.grid.2x2")
    ]

    private(set) var selectedIndex = 0
    private(set) var detailOpen = false

    var selectedItem: (title: String, subtitle: String, symbol: String) {
        items[selectedIndex]
    }

    func move(_ dx: Int, _ dy: Int) {
        guard !detailOpen else { return }
        let row = selectedIndex / 3
        let col = selectedIndex % 3
        let nextRow = min(1, max(0, row + dy))
        let nextCol = min(2, max(0, col + dx))
        selectedIndex = nextRow * 3 + nextCol
        notify()
    }

    func select() { detailOpen = true; notify() }
    func back() { detailOpen = false; notify() }
    func home() { detailOpen = false; selectedIndex = 0; notify() }

    private func notify() {
        NotificationCenter.default.post(name: Self.didChange, object: nil)
    }
}
