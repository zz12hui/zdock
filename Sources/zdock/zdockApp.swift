import SwiftUI

@main
struct zdockApp: App {
    var body: some Scene {
        Window("zdock", id: "main") {
            ContentView()
                .frame(minWidth: 600, minHeight: 400)
        }
        .defaultSize(width: Config.windowWidth, height: Config.windowHeight)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}
