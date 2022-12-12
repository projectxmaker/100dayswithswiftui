//
//  ShowActivityListViewModel.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/17/22.
//

import Foundation

class ShowActivityListViewModel: ObservableObject {
    @Published var showActivityCreationView = false
    @Published var showDeletionAlert = false
    @Published var deletedItem: ActivityItem?
    @Published var items = [ActivityItem]()
    
    private var activityManager = ActivityManager.shared
    
    init() {
        loadActivities()
    }
    
    func loadActivities() {
        items = activityManager.getActivities()
    }
    
    func deleteActivityById(_ id: UUID) {
        activityManager.deleteActivityById(id)
        loadActivities()
    }
}
