//
//  ActivityCreationView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ActivityCreationView: View {
    @StateObject var createActivityVM: CreateActivityViewModel
    
    @Environment(\.dismiss) var dismiss
    
    func createActivity() {
        createActivityVM.createActivity {
            dismiss()
        }
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

            VStack(alignment: .leading) {
                HTTextField(title: "Title", prompt: createActivityVM.promptForTitle(), value: $createActivityVM.title)
                
                HTTextField(title: "Description", prompt: createActivityVM.promptForDescription(), iconSystemName: "note.text", value: $createActivityVM.description)
                
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
                        .opacity(createActivityVM.isAllInfoValid() ? 1 : 0.6)
                        .disabled(!createActivityVM.isAllInfoValid())
                    
                    Spacer()
                }
            }
            .padding()
            
            Spacer()
        }
    }
}
