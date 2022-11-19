//
//  LogManager.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/18/22.
//

import Foundation

class RollingLogManager {
    static var shared = RollingLogManager()
    
    private var logs = [RollingLog]()
    
    let logFile = "RollingLog"
    
    init() {
        guard let logs = FileManager.default.decodeJSON(logFile) as [RollingLog]? else {
             return
         }
         
        self.logs = logs
    }
    
    func insertLog(_ rollingLog: RollingLog) {
        logs.append(rollingLog)
        save()
    }
    
    func insertLog(_ rollingLogs: [RollingLog]) {
        logs = logs + rollingLogs
        save()
    }
    
    func save() {
        _ = FileManager.default.encodeJSON(logFile, fileData: logs)
    }
    
    func getLogs() -> [RollingLog] {
        logs
    }
}
