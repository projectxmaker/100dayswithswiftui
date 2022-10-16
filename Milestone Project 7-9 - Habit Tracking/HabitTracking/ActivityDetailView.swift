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
    
    func decreaseCompletionCount() {
        completionCounter = completionCounter > 1 ? completionCounter - 1 : 0
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
            
            HStack(alignment: .center) {
                Text("Completion: \(selectedActivityItem.getCompletionCountDescription(count: completionCounter))")
                Image(systemName: "minus.circle")
                    .foregroundColor(Color.accentColor)
                    .onTapGesture {
                        decreaseCompletionCount()
                    }
            }

            Rectangle()
                .frame(width: 200, height: 2)
                .background(Color.gray.opacity(0.2))
            Text("Just completed this activity?")
            Text("Tap Me!")
                .foregroundColor(Color.white)
                .frame(width: 100, height: 40)
                .background(Color.accentColor)
                .clipShape(Capsule())
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
