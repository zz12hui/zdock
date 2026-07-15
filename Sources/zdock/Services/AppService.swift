import Cocoa

struct AppService {

    func scanAllApps() -> [AppInfo] {
        let dirs = [
            "/Applications",
            "/System/Applications",
            NSHomeDirectory() + "/Applications",
        ]
        var apps: [AppInfo] = []
        var seen = Set<String>()

        for dir in dirs {
            guard let enumerator = FileManager.default.enumerator(
                at: URL(fileURLWithPath: dir),
                includingPropertiesForKeys: [.isApplicationKey, .localizedNameKey],
                options: [.skipsPackageDescendants, .skipsHiddenFiles]
            ) else { continue }

            for case let url as URL in enumerator {
                guard !seen.contains(url.path) else { continue }
                seen.insert(url.path)

                guard let values = try? url.resourceValues(forKeys: [.isApplicationKey, .localizedNameKey]),
                      values.isApplication == true
                else { continue }

                let name = values.localizedName ?? url.deletingPathExtension().lastPathComponent
                let icon = NSWorkspace.shared.icon(forFile: url.path)
                apps.append(AppInfo(name: name, url: url, icon: icon))
            }
        }

        apps.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        return apps
    }
}
