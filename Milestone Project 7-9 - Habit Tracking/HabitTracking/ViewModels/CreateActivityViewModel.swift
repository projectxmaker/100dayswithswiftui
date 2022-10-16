//
//  CreateActivityViewModel.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/16/22.
//

import Foundation

class CreateActivityViewModel: ObservableObject {
    var activities: Activities
    
    @Published var title: String = ""
    @Published var description: String = ""
    
    init(activities: Activities) {
        self.activities = activities
    }
    
    // MARK - Extra Functions For Validation
    func isValidTitle() -> Bool {
        title.isEmpty ? false : true
    }
    
    func isValidDescription() -> Bool {
        description.isEmpty ? false : true
    }
    
    func isAllInfoValid() -> Bool {
        if !isValidTitle() || !isValidDescription() {
            return false
        }
        
        return true
    }
    
    // MARK - Extra Functions For Prompt
    func promptForTitle() -> String {
        if isValidTitle() {
            return ""
        } else {
            return "Title must not be empty"
        }
    }
    
    func promptForDescription() -> String {
        if isValidDescription() {
            return ""
        } else {
            return "Description must not be empty"
        }
    }
    
    // MARK - Extra Functions
    func createActivity(extraAction: () -> Void) {
        if isAllInfoValid() {
            let newActivity = ActivityItem(title: title, description: description)
            activities.list.insert(newActivity, at: 0)
            extraAction()
        }
    }
}
