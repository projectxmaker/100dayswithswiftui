//
//  CreateActivityViewModel.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/16/22.
//

import Foundation

class CreateActivityViewModel: ObservableObject {
    private var activityManager: ActivityManager
    
    @Published var title: String = ""
    @Published var description: String = ""
    
    init(activityManager: ActivityManager) {
        self.activityManager = activityManager
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
            activityManager.createNewActivity(newActivity)
            extraAction()
        }
    }
}
