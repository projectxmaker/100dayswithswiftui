//
//  UpdateFaceNameView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/30/22.
//

import SwiftUI

struct UpdateFaceNameView: View {
    var geometry: GeometryProxy
    var newFaceImage: UIImage
    
    @Binding var newFaceName: String
    @FocusState private var isTextFieldNameFocused: Bool
    @State private var faceName: String = ""
    
    var actionCancel: () -> Void
    var actionCreate: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Image(uiImage: newFaceImage)
                .resizable()
                .scaledToFill()
                .padding(1)
                .background(Color.white)
                .frame(maxWidth: geometry.size.width * 0.4, maxHeight: geometry.size.height * 0.25)
                .clipShape(RoundedRectangle(cornerRadius: 10))
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
            .onChange(of: faceName) { newValue in
                newFaceName = newValue
            }

            HStack {
                Button("Cancel", role: .cancel) {
                    actionCancel()
                }
                .buttonStyle(.bordered)
                
                Button {
                    actionCreate()
                } label: {
                    Text("Create")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding([.top], 20)

        }
    }
}
