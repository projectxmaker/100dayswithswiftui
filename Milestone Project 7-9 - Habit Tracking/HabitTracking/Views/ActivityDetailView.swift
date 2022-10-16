//
//  ActivityDetailView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ActivityDetailView: View {
    @State private var completionCounter: Int = 0
    @ObservedObject var activities: Activities
    
    var selectedActivityItem: ActivityItem

    func increaseCompletionCount() {
        completionCounter += 1
    }
    
    func decreaseCompletionCount() {
        completionCounter = completionCounter > 1 ? completionCounter - 1 : 0
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
            
            HTButton(title: "Tap Me!") {
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
            activities.updateCompletionCount(of: selectedActivityItem, newCompletionCount: completionCounter)
        }
    }
}
