//
//  UserDefaults+GetArray.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/16/22.
//

import Foundation

extension UserDefaults {
    func getArray<T: Codable>(dataKey: String) -> [T] {
        if let data = self.data(forKey: dataKey) {
            if let items = try? JSONDecoder().decode([T].self, from: data) {
                return items
            } else {
                fatalError("FAILED")
            }
        } else {
            return [T]()
        }
    }
}
