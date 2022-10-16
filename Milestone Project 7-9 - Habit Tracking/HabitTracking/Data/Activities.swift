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
    
    func deleteActivityById(_ id: UUID) {
        list = list.filter { item in
            return item.id != id
        }
    }
    
    func updateCompletionCount(of updatedActivityItem: ActivityItem, newCompletionCount: Int) {
        let newActivity = ActivityItem(title: updatedActivityItem.title, description: updatedActivityItem.description, completionCount: newCompletionCount)

        let selectedIndex = list.firstIndex(of: updatedActivityItem) ?? 0

        list.remove(at: selectedIndex)
        list.insert(newActivity, at: selectedIndex)
    }
}

