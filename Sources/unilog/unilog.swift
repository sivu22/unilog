import Foundation
import os.log

open class Log {
    
    private static var logger = Log()
    
    private var oslog: AnyObject?
    
    public init() {
        if #available(OSX 10.12, *) {
            oslog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "App")
        }
    }
    
    @available(OSX 10.12, *)
    public convenience init(subSystem: String = Bundle.main.bundleIdentifier!, category: String = "App") {
        self.init()
        oslog = OSLog(subsystem: subSystem, category: category)
    }
    
    @available(OSX 10.12, *)
    public func setCategory(to cat: String, forSubsystem subsystem: String = "") {
        if !cat.isEmpty {
            var subSystem = Bundle.main.bundleIdentifier!
            if !subsystem.isEmpty {
                subSystem = subsystem
            }
            oslog = OSLog(subsystem: subSystem, category: cat)
        }
    }
    
    @available(OSX 10.12, *)
    private func log(_ msg: String, type: OSLogType) {
        os_log("%s", log: oslog as! OSLog, type: type, msg)
    }
    
    private func log(_ msg: String, type: String) {
        NSLog("[%@] %@", type, msg)
    }
    
    public func debug(_ msg: String) {
        if #available(OSX 10.12, *) {
            log(msg, type: .debug)
        } else {
            log(msg, type: "DEBU")
        }
    }
    
    public func info(_ msg: String) {
        if #available(OSX 10.12, *) {
            log(msg, type: .info)
        } else {
            log(msg, type: "INFO")
        }
    }
    
    public func message(_ msg: String) {
        if #available(OSX 10.12, *) {
            log(msg, type: .default)
        } else {
            log(msg, type: "MESS")
        }
    }
    
    public func error(_ msg: String) {
        if #available(OSX 10.12, *) {
            log(msg, type: .error)
        } else {
            log(msg, type: "ERRO")
        }
    }
    
    // MARK: - Default logger
    
    @available(OSX 10.12, *)
    public static func setCategory(to cat: String, forSubsystem subsystem: String = "") {
        logger.setCategory(to: cat, forSubsystem: subsystem)
    }
    
    public static func debug(_ msg: String) {
        logger.debug(msg)
    }
    
    public static func info(_ msg: String) {
        logger.info(msg)
    }
    
    public static func message(_ msg: String) {
        logger.message(msg)
    }
    
    public static func error(_ msg: String) {
        logger.error(msg)
    }
}

extension String.StringInterpolation {
    
    public enum Modifier {
        case mPrivate
        case mPrivateRelease
        case mPublic
    }
    
    public mutating func appendInterpolation(_ value: Any?, modifier: String.StringInterpolation.Modifier = .mPublic) {
        switch modifier {
        case .mPrivate:
            if value != nil {
                appendLiteral("<redacted>")
            } else {
                appendLiteral("nil")
            }
        case .mPrivateRelease:
            if value != nil {
                #if DEBUG
                appendInterpolation(value)
                #else
                appendLiteral("<redacted>")
                #endif
            } else {
                appendLiteral("nil")
            }
        case .mPublic:
            if let value = value {
                appendInterpolation(value)
            } else {
                appendLiteral("nil")
            }
        }
    }
}
