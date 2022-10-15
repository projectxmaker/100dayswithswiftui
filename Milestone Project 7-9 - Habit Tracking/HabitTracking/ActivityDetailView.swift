//
//  ActivityDetailView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ActivityDetailView: View {
    @ObservedObject var activities: Activities
    
    var selectedActivityItem: ActivityItem
    
    @State private var completionCounter: Int = 0
    
    func increaseCompletionCount() {
        completionCounter += 1
    }
    
    func saveActivityCompletionCount() {
        let newActivity = ActivityItem(title: selectedActivityItem.title, description: selectedActivityItem.description, completionCount: completionCounter)

        let selectedIndex = activities.list.firstIndex(of: selectedActivityItem) ?? 0

        activities.list.remove(at: selectedIndex)
        activities.list.insert(newActivity, at: selectedIndex)
    }
    
    var body: some View {
        VStack {
            Text(selectedActivityItem.title)
                .font(.title.bold())
            Text(selectedActivityItem.description)
            Text("Completion: \(selectedActivityItem.getCompletionCountDescription(count: completionCounter))")
            Text("+1")
                .foregroundColor(Color.white)
                .frame(width: 50, height: 40)
                .background(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    increaseCompletionCount()
                }

            Spacer()
        }
        .navigationTitle("Activity Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            completionCounter = selectedActivityItem.completionCount
        }
        .onDisappear {
            saveActivityCompletionCount()
        }
    }
}
