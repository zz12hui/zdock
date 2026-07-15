import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool

    @AppStorage("layout_columns") private var columns: Int = 8
    @AppStorage("layout_rows") private var rows: Int = 5

    @AppStorage("theme_colorScheme") private var colorScheme: Int = 0
    @AppStorage("theme_accentColor") private var accentColor: String = "blue"
    @AppStorage("theme_iconSize") private var iconSize: Double = 64

    private let accentColors: [(name: String, label: String, color: Color)] = [
        ("blue", "蓝色", .blue),
        ("purple", "紫色", .purple),
        ("green", "绿色", .green),
        ("orange", "橙色", .orange),
        ("pink", "粉色", .pink),
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("zdock 设置").font(.title2).fontWeight(.semibold)

            Group {
                Text("外观").foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Text("配色方案")
                    Spacer()
                    Picker("", selection: $colorScheme) {
                        Text("跟随系统").tag(0)
                        Text("浅色").tag(1)
                        Text("深色").tag(2)
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                }

                HStack {
                    Text("强调色")
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(accentColors, id: \.name) { item in
                            Button { accentColor = item.name } label: {
                                Circle().fill(item.color).frame(width: 20, height: 20)
                                    .overlay(
                                        Circle().stroke(accentColor == item.name ? Color.primary : Color.clear, lineWidth: 2)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                HStack {
                    Text("图标大小")
                    Spacer()
                    Stepper(value: $iconSize, in: 48...96, step: 8) { Text("\(Int(iconSize))") }
                }
            }

            Divider()

            Group {
                Text("布局").foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("每行应用数")
                    Spacer()
                    Stepper(value: $columns, in: 4...16) { Text("\(columns)") }
                }
                HStack {
                    Text("可见行数")
                    Spacer()
                    Stepper(value: $rows, in: 2...12) { Text("\(rows)") }
                }
                Text("窗口大小: \(Int(Config.windowWidth))×\(Int(Config.windowHeight))")
                    .font(.caption).foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            Divider()

            HStack(spacing: 16) {
                Button("恢复默认") {
                    columns = 8; rows = 5
                    colorScheme = 0
                    accentColor = "blue"
                    iconSize = 64
                }
                .buttonStyle(.bordered)

                Button("完成") { isPresented = false }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(24)
        .frame(width: 360)
    }
}
