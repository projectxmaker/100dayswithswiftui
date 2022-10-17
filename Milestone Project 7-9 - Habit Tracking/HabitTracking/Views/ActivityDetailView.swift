//
//  ActivityDetailView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ActivityDetailView: View {
    @StateObject var showActivityDetailsVM: ShowActivityDetailsViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text(showActivityDetailsVM.selectedActivityItem.title)
                    .font(.title.bold())
                Text(showActivityDetailsVM.selectedActivityItem.description)
                
                HStack(alignment: .center) {
                    Text("Completion: \(showActivityDetailsVM.getCompletionCountDescription())")
                    Image(systemName: "minus.circle")
                        .foregroundColor(Color.accentColor)
                        .onTapGesture {
                            showActivityDetailsVM.decreaseCompletionCount()
                        }
                }
                
                Rectangle()
                    .frame(width: 200, height: 2)
                    .background(Color.gray.opacity(0.2))
                
                Text("Just completed this activity?")
                
                HTButton(title: "Tap Me!") {
                    showActivityDetailsVM.increaseCompletionCount()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(20)
            
            Spacer()
        }
        .navigationTitle("Activity Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
