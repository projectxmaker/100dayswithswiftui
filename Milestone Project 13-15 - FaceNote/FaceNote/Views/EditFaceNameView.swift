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
    @State private var isShowed = false
    
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
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(0.1)
                .padding([.horizontal], -20)
                .overlay {
                    Image(uiImage: viewModel.backgroundUIImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: geometry.size.width)
                        .ignoresSafeArea()
                        .blur(radius: 10, opaque: true)
                        .saturation(0.2)
                        .opacity(isShowed ? 0.7 : 0)
                    
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
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding(.top, 5)
                                .shadow(color: .black, radius: 3, x: 1, y: 1)
                        }
                        
                        HStack {
                            Button("Cancel", role: .cancel) {
                                viewModel.actionCancel()
                            }
                            .frame(minWidth: geometry.size.width * 0.2, minHeight: 40)
                            .foregroundColor(.blue)
                            .background(.white)

                            Button("Save", role: .cancel) {
                                viewModel.save()
                            }
                            .frame(minWidth: geometry.size.width * 0.2, minHeight: 40)
                            .foregroundColor(.white)
                            .background(.blue)
                            .disabled(!viewModel.isFaceNameValid())
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .buttonStyle(PlainButtonStyle())
                        .padding([.top], 20)
                        .shadow(color: .white, radius: 10, x: 1, y: 1)
                        
                        
                    }
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isShowed.toggle()
                    }
                }
        }
    }
}
