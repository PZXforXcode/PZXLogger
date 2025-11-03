//
//  PZXLogger.swift
//  PZXLogger
//
//  Created by 彭祖鑫 on 2025/11/3.
//

import Foundation
import UIKit

/// 日志级别定义
enum PZXLogLevel: String {
    case debug = "DEBUG"
    case info  = "INFO"
    case warning = "WARN"
    case error = "ERROR"
    
    /// 日志等级前缀图标
    var emoji: String {
        switch self {
        case .debug: return "💙"
        case .info: return "💚"
        case .warning: return "💛"
        case .error: return "❤️"
        }
    }
}

/// 日志工具类
struct PZXLogger {
    
    /// 是否启用日志输出
    static var isEnabled: Bool = true
    
    /// 是否保存日志到文件
    static var enableFileLogging: Bool = true
    
    /// 保留日志的天数（自动清理超过该天数的文件）
    static var keepDays: Int = 7
    
    /// 日期格式化器
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
    
    /// 日志文件路径（按日期存储）
    private static var logFileURL: URL? {
        let fileManager = FileManager.default
        guard let docDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let logDir = docDir.appendingPathComponent("logs")
        if !fileManager.fileExists(atPath: logDir.path) {
            try? fileManager.createDirectory(at: logDir, withIntermediateDirectories: true)
        }
        let fileName = "log_\(dateString(format: "yyyy-MM-dd")).txt"
        return logDir.appendingPathComponent(fileName)
    }
    
    /// 打印日志
    static func log(
        _ level: PZXLogLevel,
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isEnabled else { return }
        
        let now = dateFormatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let logString = "\(now) \(level.emoji) [\(level.rawValue)] \(fileName):\(line) \(function) - \(message)"
        
        // 控制台打印
        print(logString)
        
        // 写入文件
        if enableFileLogging {
            writeLogToFile(logString + "\n")
        }
    }
    
    /// 写入日志到文件（每次写入时自动触发旧日志清理）
    private static func writeLogToFile(_ text: String) {
        guard let logURL = logFileURL else { return }
        
        if let data = text.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logURL.path) {
                if let fileHandle = try? FileHandle(forWritingTo: logURL) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                try? data.write(to: logURL)
            }
        }
        
        // 📆 自动清理旧日志
        cleanOldLogs(olderThan: keepDays)
    }
    
    /// 获取指定格式的日期字符串
    private static func dateString(format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: Date())
    }
    
    // MARK: - 📆 自动清理旧日志
    /// 删除指定天数之前的日志文件
    static func cleanOldLogs(olderThan days: Int) {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let logDir = docDir.appendingPathComponent("logs")
        let fileManager = FileManager.default
        
        guard let files = try? fileManager.contentsOfDirectory(at: logDir, includingPropertiesForKeys: [.creationDateKey], options: []) else { return }
        
        let expirationDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        for file in files {
            if let attrs = try? fileManager.attributesOfItem(atPath: file.path),
               let creationDate = attrs[.creationDate] as? Date,
               creationDate < expirationDate {
                try? fileManager.removeItem(at: file)
                print("🧹 自动清理旧日志: \(file.lastPathComponent)")
            }
        }
    }
    
    // MARK: - 🧹 主动清理日志
    /// 删除所有日志文件
    static func clearAllLogs() {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let logDir = docDir.appendingPathComponent("logs")
        let fileManager = FileManager.default
        
        guard let files = try? fileManager.contentsOfDirectory(at: logDir, includingPropertiesForKeys: nil) else { return }
        for file in files {
            try? fileManager.removeItem(at: file)
        }
        print("🧼 所有日志已清理完毕")
    }
    
    // MARK: - 📤 导出日志文件
    /// 获取当天日志文件的 URL
    static func currentLogFileURL() -> URL? {
        return logFileURL
    }
    
    /// 打开系统分享面板导出日志文件
    static func exportLog(from viewController: UIViewController) {
        guard let url = logFileURL, FileManager.default.fileExists(atPath: url.path) else {
            print("❌ 日志文件不存在，无法导出")
            return
        }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        viewController.present(activityVC, animated: true)
    }
}

 
// MARK: - 快捷函数
func PZXLogInfo(
    _ message: String,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
    PZXLogger.log(.info, message, file: file, function: function, line: line)
}

func PZXLogDebug(
    _ message: String,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
    PZXLogger.log(.debug, message, file: file, function: function, line: line)
}

func PZXLogError(
    _ message: String,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
    PZXLogger.log(.error, message, file: file, function: function, line: line)
}

func PZXLogWarn(
    _ message: String,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
    PZXLogger.log(.warning, message, file: file, function: function, line: line)
}
