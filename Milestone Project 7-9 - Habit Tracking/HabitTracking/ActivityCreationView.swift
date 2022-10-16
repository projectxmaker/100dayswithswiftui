//
//  ActivityCreationView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ActivityCreationView: View {
    @ObservedObject var activities: Activities
    
    @State private var title = ""
    @State private var description = ""
    
    @Environment(\.dismiss) var dismiss
    
    func createActivity() {
        let newActivity = ActivityItem(title: title, description: description)
        activities.list.insert(newActivity, at: 0)
        dismiss()
    }
    
    func cancelCreatingActivity() {
        dismiss()
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Spacer()
                Text("New Activity")
                    .font(.largeTitle.bold())
                Spacer()
            }
            .frame(height: 80)

            Form {    
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                
                HStack(alignment: .center) {
                    Spacer()
                    
                    HTButton(
                        title: "Cancel",
                        background: .red) {
                            cancelCreatingActivity()
                        }
                    
                    Spacer()
                    
                    HTButton(
                        title: "Create") {
                            createActivity()
                        }
                    
                    Spacer()
                }
            }
            
        }
        .navigationBarTitle("TTT")
    }
}
