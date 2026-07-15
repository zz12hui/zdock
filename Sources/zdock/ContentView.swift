import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()
    @State private var hoverId: UUID?
    @FocusState private var focused: Bool
    @State private var showSettings = false
    @AppStorage("layout_columns") private var columnsCount = 8

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 20), count: columnsCount)
    }

    var body: some View {
        VStack(spacing: 24) {
            searchBar
                .padding(.top, 40)

            if vm.filteredApps.isEmpty && !vm.searchText.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass").font(.system(size: 36)).foregroundColor(.secondary)
                    Text("没有找到").foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(vm.filteredApps) { app in appCell(app) }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            VisualEffectView()
                .ignoresSafeArea()
        }
        .onAppear {
            vm.load()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { focused = true }
        }
        .overlay(alignment: .bottom) {
            Text("Esc 隐藏").font(.caption).foregroundColor(.secondary.opacity(0.4)).padding(.bottom, 12)
        }
        .onKeyPress(.escape) {
            NSApp.hide(nil)
            return .handled
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField("搜索应用", text: $vm.searchText)
                .textFieldStyle(.plain)
                .font(.title2)
                .focused($focused)
                .onSubmit {
                    if let first = vm.filteredApps.first {
                        vm.open(first)
                        closeWindow()
                    }
                }
            if !vm.searchText.isEmpty {
                Button { vm.searchText = ""; focused = true } label: {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                }.buttonStyle(.plain)
            }

            Button { showSettings = true } label: {
                Image(systemName: "gearshape.fill").foregroundColor(.secondary).font(.caption)
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showSettings) {
                SettingsView(isPresented: $showSettings)
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: 440)
    }

    private func appCell(_ app: AppInfo) -> some View {
        Button {
            vm.open(app)
            closeWindow()
        } label: {
            VStack(spacing: 6) {
                Image(nsImage: app.icon)
                    .resizable().frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .black.opacity(0.12), radius: 3, y: 1)
                Text(app.name).font(.caption).lineLimit(1).frame(width: 80)
            }
            .padding(8)
            .background(hoverId == app.id ? Color.white.opacity(0.1) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .scaleEffect(hoverId == app.id ? 1.08 : 1)
        .animation(.spring(duration: 0.2), value: hoverId)
        .onHover { hoverId = $0 ? app.id : nil }
    }

    private func closeWindow() {
        NSApp.keyWindow?.close()
    }
}

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let v = NSVisualEffectView()
        v.material = .hudWindow
        v.blendingMode = .behindWindow
        v.state = .active
        return v
    }
    func updateNSView(_ v: NSVisualEffectView, context: Context) {}
}
