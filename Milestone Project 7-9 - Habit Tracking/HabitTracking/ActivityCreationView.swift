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
    
    var body: some View {
        VStack {
            Form {
                HStack(alignment: .center) {
                    Spacer()
                    Text("New Activity")
                        .font(.largeTitle)
                    Spacer()
                }

                TextField("Title", text: $title)
                TextField("Description", text: $description)
                
                HStack(alignment: .center) {
                    Spacer()
                    Button {
                        createActivity()
                    } label: {
                        Text("Create")
                            .foregroundColor(.white)
                            .frame(width: 100, height: 40)
                            .background(Capsule())
                    }
                    Spacer()
                }

            }
        }
    }
}
