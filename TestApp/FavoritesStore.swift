import Foundation

/// Deterministic, local persistence for favorite items.
/// UserDefaults-backed so the state survives app relaunches (that's the point of the lab screen).
/// A custom UserDefaults instance can be injected for unit tests.
struct FavoritesStore {

    private static let key = "lab_favorite_items"

    private let defaults: UserDefaults

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    func all() -> [String] {
        return defaults.stringArray(forKey: FavoritesStore.key) ?? []
    }

    func isFavorite(_ item: String) -> Bool {
        return all().contains(item)
    }

    @discardableResult
    func toggle(_ item: String) -> Bool {
        var current = all()
        if let index = current.index(of: item) {
            current.remove(at: index)
        } else {
            current.append(item)
            current.sort()
        }
        defaults.set(current, forKey: FavoritesStore.key)
        return current.contains(item)
    }

    func reset() {
        defaults.removeObject(forKey: FavoritesStore.key)
    }
}
