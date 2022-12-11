//
//  ActivityCreationView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ActivityCreationView: View {
    @StateObject var createActivityVM = CreateActivityViewModel()
    
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
            VStack {
                VStack(alignment: .center) {
                    Spacer()
                    Text("New Activity")
                        .font(.largeTitle.bold())
                    Spacer()
                }
                .frame(height: 80)
                
                VStack(alignment: .leading) {
                    HTTextInput(
                        title: "Title",
                        prompt: createActivityVM.promptForTitle(),
                        value: $createActivityVM.title
                    )
                    
                    HTTextInput(
                        title: "Description",
                        prompt: createActivityVM.promptForDescription(),
                        iconSystemName: "note.text",
                        textInputType: .textEditor,
                        value: $createActivityVM.description
                    )
                    
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
                .padding(20)

            }
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(20)

            Spacer()
        }
    }
}
