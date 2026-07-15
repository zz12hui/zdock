import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool

    @AppStorage("layout_columns") private var columns: Int = 8
    @AppStorage("layout_rows") private var rows: Int = 5

    var body: some View {
        VStack(spacing: 24) {
            Text("zdock 设置").font(.title2).fontWeight(.semibold)

            Group {
                Text("布局").foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("每行应用数")
                    Spacer()
                    Stepper(value: $columns, in: 4...16) { Text("\(columns)") }
                }
                HStack {
                    Text("默认显示行数")
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
                }
                .buttonStyle(.bordered)

                Button("完成") { isPresented = false }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(24)
        .frame(width: 340)
    }
}
