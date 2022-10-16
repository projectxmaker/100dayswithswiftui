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
        self.list = UserDefaults.standard.getArray(dataKey: activityItemsDataKey)
    }
    
    // MARK: - Extra Functions
    
    func deleteActivityById(_ id: UUID) {
        list = list.filter { item in
            return item.id != id
        }
    }
    
    func updateCompletionCount(of updatedActivityItem: ActivityItem, newCompletionCount: Int) {
        guard
            newCompletionCount >= 0,
            let selectedIndex = list.firstIndex(of: updatedActivityItem) else {
            return
        }
        
        list[selectedIndex].completionCount = newCompletionCount
    }
}

