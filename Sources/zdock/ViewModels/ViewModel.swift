import Cocoa
import Combine

@MainActor
final class ViewModel: ObservableObject {
    @Published var allApps: [AppInfo] = []
    @Published var searchText = ""

    private let service = AppService()

    var filteredApps: [AppInfo] {
        if searchText.isEmpty { return allApps }
        return allApps.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    func load() {
        allApps = service.scanAllApps()
    }

    func open(_ app: AppInfo) {
        let config = NSWorkspace.OpenConfiguration()
        config.activates = true
        NSWorkspace.shared.openApplication(at: app.url, configuration: config)
    }
}
