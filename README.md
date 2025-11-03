# 📘 PZXLogger

> 🧩 A lightweight Swift logger with colorful console output, file saving, auto-cleaning, and export support.  
> 🧩 一个轻量级的 Swift 日志工具，支持彩色控制台输出、日志文件保存、自动清理与导出。

---

## ✨ Features 功能特性

- 🌈 **Colorful console output 彩色控制台输出**  
  Different log levels are displayed with distinct emoji for better readability.  
  不同日志等级使用不同的 Emoji 区分，清晰直观。

- 📄 **Log file saving 日志文件保存**  
  Logs are automatically stored in the app's `Documents/logs` directory.  
  自动保存到应用的 `Documents/logs` 目录中。

- 📆 **Auto-clean old logs 自动清理旧日志**  
  Keeps only the most recent 7 days of logs by default.  
  默认仅保留最近 7 天的日志文件。

- 🧹 **Manual log cleaning 主动清理日志**  
  Clear all log files with one method call.  
  可通过一个方法清空所有日志文件。

- 📤 **Export logs 导出日志**  
  Share `.txt` log files through iOS system share sheet.  
  可通过系统分享面板导出 `.txt` 日志文件。

---

## 🧩 Usage Example 使用示例

```swift
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PZXLogInfo("应用启动成功 / App launched successfully")
        PZXLogDebug("加载配置中... / Loading configuration...")
        PZXLogWarn("电量较低 / Battery low")
        PZXLogError("蓝牙连接失败 / Bluetooth connection failed")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 📤 Export today's log file 导出今日日志文件
        PZXLogger.exportLog(from: self)
        
        // 🧹 Clear all log files 清空所有日志文件
        // PZXLogger.clearAllLogs()
    }
}
