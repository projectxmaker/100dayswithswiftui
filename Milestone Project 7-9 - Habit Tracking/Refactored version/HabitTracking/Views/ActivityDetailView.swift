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
                    .multilineTextAlignment(.center)
                
                Rectangle()
                    .frame(width: 200, height: 2)
                    .background(Color.gray.opacity(0.2))
                
                HStack(alignment: .center) {
                    Text("You did \(showActivityDetailsVM.getCompletionCountDescription())")
                    Image(systemName: "minus.circle")
                        .foregroundColor(Color.accentColor)
                        .onTapGesture {
                            showActivityDetailsVM.decreaseCompletionCount()
                        }
                }
                
                Text("Just completed this activity?")
                
                HTButton(title: "Yes!") {
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

struct ActivityDetailView_Previewer: PreviewProvider {
    struct SampleView: View {
        var body: some View {
            ActivityDetailView(showActivityDetailsVM: ShowActivityDetailsViewModel(selectedActivityItem: ActivityItem.sampleActivityItems[0]))
        }
    }
    
    static var previews: some View {
        SampleView()
    }
}
