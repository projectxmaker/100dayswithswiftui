//
//  ActivityCreationView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ActivityCreationView: View {
    @State private var activity = ""
    @State private var description = ""
    
    @Environment(\.dismiss) var dismiss
    
    func createActivity() {
        dismiss()
    }
    
    var body: some View {
        VStack {
            Form {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Create New Activity")
                        .font(.largeTitle)
                    Spacer()
                }

                TextField("Activity", text: $activity)
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

struct ActivityCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCreationView()
    }
}
