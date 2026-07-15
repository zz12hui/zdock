import Foundation

enum Config {
    @Storage(key: "layout_columns", default: 8)
    static var columnCount: Int

    @Storage(key: "layout_rows", default: 5)
    static var visibleRows: Int

    static var windowWidth: CGFloat {
        let cell: CGFloat = 88
        let spacing: CGFloat = 20
        let pad: CGFloat = 64
        return CGFloat(columnCount) * cell + CGFloat(columnCount - 1) * spacing + pad
    }

    static var windowHeight: CGFloat {
        let header: CGFloat = 120
        return CGFloat(visibleRows) * 100 + CGFloat(visibleRows - 1) * 20 + header
    }
}

@propertyWrapper
struct Storage<T> {
    let key: String
    let `default`: T
    let store = UserDefaults.standard

    var wrappedValue: T {
        get { store.object(forKey: key) as? T ?? `default` }
        set { store.set(newValue, forKey: key) }
    }
}
