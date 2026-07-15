import Cocoa

struct AppInfo: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
    let icon: NSImage
}
