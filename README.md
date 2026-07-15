# 🚀 zdock

> 纯 SwiftUI 打造的 macOS 全屏应用启动器 — 搜索、点击、起飞。

<p align="center">
  <img src="screenshot.png" alt="zdock 截图" width="720"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-14.0%2B-blue?logo=apple" alt="macOS">
  <img src="https://img.shields.io/badge/Swift-5.9%2B-orange?logo=swift" alt="Swift">
  <img src="https://img.shields.io/badge/arch-arm64-silver" alt="Arch">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
</p>

---

## ✨ 特性

- **全屏沉浸** — 磨砂玻璃背景，应用图标网格铺满屏幕，视觉干扰降到最低
- **极速搜索** — 键入应用名或首字母，毫秒级过滤，回车即启动
- **键盘优先** — `Esc` 隐藏窗口、`Enter` 打开应用，手不离键盘
- **悬浮动效** — 鼠标划过图标时弹簧缩放 + 高亮，触感反馈拉满
- **可调布局** — 列数（4–16）× 行数（2–12），窗口尺寸自动适配
- **零依赖** — `swiftc` 直接编译，不依赖 SwiftPM / Xcode 工程

---

## 🎬 操作速览

| 操作 | 快捷键 / 方式 |
|------|-------------|
| 打开 | 启动 `zdock.app` |
| 🔍 搜索 | 直接输入（支持拼音首字母） |
| ▶️ 启动应用 | 点击图标 / 搜索后 `Enter` |
| 🙈 隐藏窗口 | `Esc` |
| ⚙️ 设置 | 点击顶栏 ⚙ 图标 |

---

## 📁 项目结构

```
Sources/zdock/
├── zdockApp.swift              # @main 入口，Window 场景
├── ContentView.swift           # 主界面：搜索栏 + 网格 + Esc 隐藏
├── Models/
│   └── AppInfo.swift           # 应用信息模型（name / url / icon）
├── Services/
│   ├── AppService.swift        # 扫描 /Applications 获取全部 App
│   └── Config.swift            # 布局配置 + @Storage 属性包装器
├── ViewModels/
│   └── ViewModel.swift         # @Published 状态管理
└── Views/
    └── SettingsView.swift      # 设置弹窗（列数 / 行数）
```

---

## 🔧 构建

```bash
./build.sh
# 输出 → zdock.app
```

### build.sh 做了什么

1. `swiftc` 编译所有 Swift 源文件 → `.build/zdock`
2. 创建 `.app` 包结构，拷贝二进制 + `Info.plist` + 图标
3. `codesign` 本地签名

---

## ⚙️ 配置

通过设置面板调整，持久化到 `UserDefaults`：

| 键 | 默认值 | 范围 | 说明 |
|---|:---:|:---:|---|
| `layout_columns` | `8` | 4–16 | 每行应用数 |
| `layout_rows` | `5` | 2–12 | 默认显示行数 |

窗口尺寸自动计算：

```
windowWidth  = 88 × columns  + 20 × (columns  - 1) + 64
windowHeight = 100 × rows    + 20 × (rows    - 1) + 140
```

---

## 🧱 技术要点

| 能力 | 实现 |
|------|------|
| 磨砂背景 | `NSViewRepresentable` 桥接 `NSVisualEffectView` |
| 键盘事件 | SwiftUI 3+ `onKeyPress(.escape)` |
| 应用扫描 | `FileManager` 递归遍历 3 个目录，去重 + 字母排序 |
| 持久化 | 自定义 `@Storage` 属性包装器 → `UserDefaults` |
| 打开应用 | `NSWorkspace.shared.openApplication(at:configuration:)` |

---

## 🗺️ 路线图

- [ ] 自定义图标包 / 主题
- [ ] Alfred 风格 Actions（文件搜索、剪贴板…）
- [ ] 快捷键唤起 / 全局热键
- [ ] 插件系统

---

## 📄 License

MIT © 2025
