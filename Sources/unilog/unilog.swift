import Foundation
import os.log

open class Log {
    
    private static var logger = Log()
    
    private var oslog: AnyObject?
    private var privateDebug = false
    
    init() {
        if #available(OSX 10.12, *) {
            oslog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "App")
        }
    }
    
    @available(OSX 10.12, *)
    convenience init(subSystem: String = Bundle.main.bundleIdentifier!, category: String = "App") {
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
    
    public func allowPrivateInDebugMode(_ allow: Bool) {
        privateDebug = allow
    }
    
    private func parse(_ msg: String) -> String {
        guard !msg.isEmpty else {
            return ""
        }
        
        if msg.count < 4 || !msg.contains("{<}") {
            return msg
        }
        
        let failedMsg = "<Unsupported characters found, message will not be logged>"
        
        var startIndexes: [String.Index] = [], stopIndexes: [String.Index] = []
        for i in 0..<msg.count - 2 {
            let start = msg.index(msg.startIndex, offsetBy: i)
            if msg[start] != "{" {
                continue
            }
            
            let stop = msg.index(msg.startIndex, offsetBy: i + 2)
            let token = msg[start...stop]
            if token == "{<}" {
                startIndexes.append(start)
            } else if token == "{>}" {
                stopIndexes.append(start)
            }
        }
        
        if startIndexes.count != stopIndexes.count {
            return failedMsg
        }
        
        if startIndexes.count == 0 {
            return msg
        }
        
        for i in 0..<startIndexes.count {
            if startIndexes[i] > stopIndexes[i] {
                return failedMsg
            }
        }
        
        var redactedMsg = msg
        var redacted = "<redacted>"
        #if DEBUG
        if !privateDebug {
            redacted = ""
        }
        #endif
        
        if !redacted.isEmpty {
            for i in stride(from: startIndexes.count - 1, through: 0, by: -1) {
                redactedMsg = redactedMsg.replacingCharacters(in: startIndexes[i]..<stopIndexes[i], with: redacted)
            }
        }
        
        redactedMsg = redactedMsg.replacingOccurrences(of: "{<}", with: "")
        redactedMsg = redactedMsg.replacingOccurrences(of: "{>}", with: "")
        
        return redactedMsg
    }
    
    @available(OSX 10.12, *)
    private func log(_ msg: String, type: OSLogType) {
        os_log("%s", log: oslog as! OSLog, type: type, parse(msg))
    }
    
    private func log(_ msg: String, type: String) {
        NSLog("[%@] %@", type, parse(msg))
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
    
    public static func allowPrivateInDebugMode(_ allow: Bool) {
        logger.allowPrivateInDebugMode(allow)
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
