//
//  LogManager.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/18/22.
//

import Foundation

class RollingLogManager {
    struct DiceGroupInfo {
        var numberOfDices: Double
        var numberOfPossibilities: Double
        var result: String
        var sumOfResult: Int
        var highestResult: Int
        var lowestResult: Int
    }
    
    static var shared = RollingLogManager()
    
    private var logs = [RollingLog]()
    
    private var groups = [UUID: DiceGroupInfo]()
    private var groupOfDices = [UUID: [Dice]]()
    
    let logFile = "RollingLog"
    
    init() {
        guard let logs = FileManager.default.decodeJSON(logFile) as [RollingLog]? else {
             return
         }
         
        self.logs = logs
    }
    
    func insertLogGroup(of groupId: UUID) {
        guard
            let groupInfo = groups[groupId],
            let groupOfDice = groupOfDices[groupId]
        else {
            return
        }
        
        var results = [Int]()
        for eachDice in groupOfDice {
            results.append(eachDice.visibleValue)
        }
        
        let sortedResults = results.sorted()
        let highestResult = sortedResults.first ?? 0
        let lowestResult = sortedResults.last ?? 0

        let rollingLog = RollingLog(
            dices: groupInfo.numberOfDices,
            posibilities: groupInfo.numberOfPossibilities,
            result: results.map(String.init).joined(separator: ","),
            sumOfResult: results.reduce(0, +),
            highestResult: highestResult,
            lowestResult: lowestResult
        )

        logs.insert(rollingLog, at: 0)
        save()
    }
    
    func save() {
        _ = FileManager.default.encodeJSON(logFile, fileData: logs)
    }
    
    func getLogs() -> [RollingLog] {
        logs
    }
    
    func generateNewGroup(numberOfDices: Double, numberOfPossibilities: Double) -> UUID {
        let newId = UUID()
        
        let groupInfo = RollingLogManager.DiceGroupInfo(
            numberOfDices: numberOfDices,
            numberOfPossibilities: numberOfPossibilities,
            result: "",
            sumOfResult: 0,
            highestResult: 0,
            lowestResult: 0
        )
        
        groups[newId] = groupInfo
        groupOfDices[newId] = [Dice]()
        
        return newId
    }
    
    func logDice(of dice: Dice) {
        guard
            let groupId = dice.groupId,
            let group = groups[groupId],
            let _ = groupOfDices[groupId]
        else {
            return
        }
        
        // add this dice to related group of dice
        groupOfDices[groupId]?.append(dice)
        if Int(group.numberOfDices) == groupOfDices[groupId]?.count {
            // save log
            insertLogGroup(of: groupId)
            
            // remove this log group
            groups.removeValue(forKey: groupId)
            groupOfDices.removeValue(forKey: groupId)
        }
    }
}
