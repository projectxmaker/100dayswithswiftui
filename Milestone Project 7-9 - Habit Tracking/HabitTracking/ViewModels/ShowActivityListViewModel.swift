//
//  ShowActivityListViewModel.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/17/22.
//

import Foundation

class ShowActivityListViewModel: ObservableObject {
    @Published private var activities = Activities()
    
    func getActivities() -> [ActivityItem] {
        activities.getActivities()
    }
    
    func deleteActivityById(_ id: UUID) {
        activities.deleteActivityById(id)
    }
}
