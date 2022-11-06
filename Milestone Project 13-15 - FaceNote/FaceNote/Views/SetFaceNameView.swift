//
//  UpdateFaceNameView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/30/22.
//

import SwiftUI

enum ActionType {
    case create, update
}

struct SetFaceNameView: View {
    @EnvironmentObject var faceList: FaceList

    @State private var isShowed = false
    @State private var backgroundImage = UIImage()
    @State private var mainImage = UIImage()
    @State private var faceName: String = ""
    
    @FocusState private var isTextFieldNameFocused: Bool
   
    var actionType: ActionType
    var geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(0.1)
                .padding([.horizontal], -20)
                .overlay {
                    Image(uiImage: backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: geometry.size.width)
                        .ignoresSafeArea()
                        .blur(radius: 10, opaque: true)
                        .saturation(0.2)
                        .opacity(isShowed ? 0.7 : 0)
                    
                    VStack(spacing: 0) {
                        Image(uiImage: mainImage)
                            .resizable()
                            .scaledToFill()
                            .padding(1)
                            .background(Color.white)
                            .frame(maxWidth: geometry.size.width * 0.4, maxHeight: geometry.size.height * 0.25)
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 10, x: 1, y: 1)
                        
                        TextField(text: $faceName, prompt: Text("Enter name here")) {
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
                        
                        if !faceList.isFaceNameValid(name: faceName) {
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
                                faceList.save(actionType: actionType, faceName: faceName)
                            }
                            .frame(minWidth: geometry.size.width * 0.2, minHeight: 40)
                            .foregroundColor(.white)
                            .background(.blue)
                            .disabled(!faceList.isFaceNameValid(name: faceName))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .buttonStyle(PlainButtonStyle())
                        .padding([.top], 20)
                        .shadow(color: .white, radius: 10, x: 1, y: 1)
                        
                        
                    }
                }

        }
        .onAppear {
            switch actionType {
            case .create:
                self.mainImage = faceList.mainUIImage(geometry: geometry, uiImage: faceList.newFaceImage)
                self.backgroundImage = faceList.backgroundUIImage(uiImage: faceList.newFaceImage)
            case .update:
                faceName = faceList.tappedFace?.name ?? "Unknown"
                self.backgroundImage = faceList.backgroundUIImage(face: faceList.tappedFace)
                self.mainImage = faceList.mainUIImage(geometry: geometry, face: faceList.tappedFace)
            }
            
            withAnimation(.easeOut(duration: 0.5)) {
                isShowed.toggle()
            }
        }
    }
}
