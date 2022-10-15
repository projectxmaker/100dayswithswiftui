//
//  Activities.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import Foundation

class Activities: ObservableObject {
    @Published var list: [ActivityItem] {
        didSet {
            if let data = try? JSONEncoder().encode(list) {
                UserDefaults.standard.set(data, forKey: activityItemsDataKey)
            }
        }
    }
    
    let activityItemsDataKey = "ActivityItems"
    
    init() {
        self.list = UserDefaults.standard.getActivityItems(dataKey: activityItemsDataKey)
    }
}

extension UserDefaults {
    func getActivityItems<T: Codable>(dataKey: String) -> [T] {
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

