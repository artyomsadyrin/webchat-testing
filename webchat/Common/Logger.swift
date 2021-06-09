//
//  Logger.swift
//  webchat
//
//  Created by Artsiom Sadyryn on 9.06.21.
//

import Foundation

final class Logger {
    private static let logDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = .current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSxx"
        return formatter
    }()
    
    enum Event: String {
        case error = "‼️ ERROR"
        case info = "ℹ️ INFO"
        case debug = "💙 DEBUG"
        case warning = "⚠️ WARNING"
    }
}

extension Logger {
    static func log(_ message: Any,
                          _ event: Event,
                          fileName: String? = #file,
                          line: Int? = #line,
                          funcName: String? = #function) {
        if event == .info || event == .error {
            print("\(logDateFormatter.string(from: Date())) \(event.rawValue) -> '\(message)'")
        } else {
            let fileName = fileName.map { "[\(sourceFileName(filePath: $0))]" } ?? ""
            let line = line.map { ":\($0)" } ?? ""
            let funcName = funcName ?? ""
            print("\(logDateFormatter.string(from: Date())) \(event.rawValue)" + fileName + line + funcName + " -> '\(message)'")
        }
    }
}

private extension Logger {
    static func sourceFileName(filePath: String) -> String {
        filePath.components(separatedBy: "/").last ?? ""
    }
}
