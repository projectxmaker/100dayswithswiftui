//
//  FaceFormView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/6/22.
//

import SwiftUI

struct FaceFormView: View {
    @EnvironmentObject var setFaceInfoVM: SetFaceInfoViewModel
    @EnvironmentObject var faceList: FaceList

    @State private var isShowed = false
    
    @FocusState private var isTextFieldNameFocused: Bool
   
    var geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(0.1)
                .padding([.horizontal], -20)
                .overlay {
                    Image(uiImage: setFaceInfoVM.backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: geometry.size.width)
                        .ignoresSafeArea()
                        .blur(radius: 10, opaque: true)
                        .saturation(0.2)
                        .opacity(isShowed ? 0.7 : 0)
                    
                    VStack(spacing: 0) {
                        Image(uiImage: setFaceInfoVM.mainImage)
                            .resizable()
                            .scaledToFill()
                            .padding(1)
                            .background(Color.white)
                            .frame(maxWidth: geometry.size.width * 0.4, maxHeight: geometry.size.height * 0.25)
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 10, x: 1, y: 1)
                        
                        TextField(text: $setFaceInfoVM.faceName, prompt: Text("Enter name here")) {
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
                        
                        if !setFaceInfoVM.isFaceNameValid() {
                            Text("Name must have at least 1 character")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding(.top, 5)
                                .shadow(color: .black, radius: 3, x: 1, y: 1)
                        }
                        
                        HStack {
                            Button("Cancel", role: .cancel) {
                                faceList.cancelAction()
                            }
                            .frame(minWidth: geometry.size.width * 0.2, minHeight: 40)
                            .foregroundColor(.blue)
                            .background(.white)

                            Button("Save", role: .cancel) {
                                setFaceInfoVM.save(actionDone: faceList.updateFaceDone)
                            }
                            .frame(minWidth: geometry.size.width * 0.2, minHeight: 40)
                            .foregroundColor(.white)
                            .background(.blue)
                            .disabled(!setFaceInfoVM.isFaceNameValid())
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .buttonStyle(PlainButtonStyle())
                        .padding([.top], 20)
                        .shadow(color: .white, radius: 10, x: 1, y: 1)
                    }
                }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isShowed.toggle()
            }
        }
    }
}

