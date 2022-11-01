//
//  UpdateFaceNameView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/30/22.
//

import SwiftUI

struct EditFaceNameView: View {
    @StateObject private var viewModel: ViewModel
    var geometry: GeometryProxy
    
    @FocusState private var isTextFieldNameFocused: Bool

    init(geometry: GeometryProxy, newFaceImage: UIImage, actionCancel: @escaping () -> Void, actionSave: @escaping (EditFaceNameView.ViewModel.ActionType, Bool, Face?) -> Void) {
        self.geometry = geometry
        
        self._viewModel = StateObject(wrappedValue: ViewModel(newFaceImage: newFaceImage, actionCancel: actionCancel, actionSave: actionSave))
    }
    
    init(geometry: GeometryProxy, face: Face, actionCancel: @escaping () -> Void, actionSave: @escaping (EditFaceNameView.ViewModel.ActionType, Bool, Face?) -> Void) {
        self.geometry = geometry
        
        self._viewModel = StateObject(wrappedValue: ViewModel(face: face, actionCancel: actionCancel, actionSave: actionSave))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image(uiImage: viewModel.faceImage)
                .resizable()
                .scaledToFill()
                .padding(1)
                .background(Color.white)
                .frame(maxWidth: geometry.size.width * 0.4, maxHeight: geometry.size.height * 0.25)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 10, x: 1, y: 1)

            TextField(text: $viewModel.faceName, prompt: Text("Enter name here")) {
                Text("Name")
            }
            .focused($isTextFieldNameFocused)
            .padding(15)
            .background(.white)
            .frame(maxWidth: geometry.size.width * 0.6)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .gray, radius: 5, x: 1, y: 1)
            .padding(.top, 5)
            .onAppear {
                isTextFieldNameFocused.toggle()
            }

            if !viewModel.isFaceNameValid() {
                Text("Name must have at least 1 character")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
                

            HStack {
                Button("Cancel", role: .cancel) {
                    viewModel.actionCancel()
                }
                .buttonStyle(.bordered)
                
                Button {
                    viewModel.save()
                } label: {
                    Text("Save")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isFaceNameValid())
            }
            .padding([.top], 20)

        }
    }
}
