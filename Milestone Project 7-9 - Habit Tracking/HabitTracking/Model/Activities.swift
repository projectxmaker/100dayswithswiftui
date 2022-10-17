//
//  Activities.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import Foundation

struct Activities {
    private var list: [ActivityItem] {
        didSet {
            if let data = try? JSONEncoder().encode(list) {
                UserDefaults.standard.set(data, forKey: activityItemsDataKey)
            }
        }
    }
    
    let activityItemsDataKey = "ActivityItems"
    
    init() {
        self.list = UserDefaults.standard.getArray(dataKey: activityItemsDataKey)
    }
    
    // MARK: - Extra Functions
    func getActivities() -> [ActivityItem] {
        return list
    }
    
    mutating func deleteActivityById(_ id: UUID) {
        list = list.filter { item in
            return item.id != id
        }
    }
    
    mutating func updateAnActivity(_ activityItem: ActivityItem) {
        guard let selectedIndex = list.firstIndex(of: activityItem) else {
            return
        }
        
        list[selectedIndex] = activityItem
    }
}

