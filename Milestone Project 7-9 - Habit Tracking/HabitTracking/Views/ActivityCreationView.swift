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

            Form {
                HTTextField(value: $createActivityVM.title, prompt: createActivityVM.promptForTitle(), title: "Title")
                
                HTTextField(value: $createActivityVM.description, prompt: createActivityVM.promptForDescription(), title: "Description")
                
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
        }
        .navigationBarTitle("TTT")
    }
}
