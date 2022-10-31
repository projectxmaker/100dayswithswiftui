//
//  ListView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

struct ListView: View {
    @State private var showingImagePicker = false
    @State private var showFormToSetFaceName = false
    @FocusState private var isTextFieldNameFocused: Bool
    @State private var newFaceName = ""
    
    var geometry: GeometryProxy
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            FaceList(faces: $viewModel.faces)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showingImagePicker = true
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(.blue.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }

            if showFormToSetFaceName {
                Color.white
                    .opacity(0.8)
                    .onTapGesture {
                        showFormToSetFaceName = false
                    }

                UpdateFaceNameView(geometry: geometry, newFaceImage: viewModel.wrappedNewFaceImage, newFaceName: $viewModel.newFaceName) {
                    // save name
                    // close this form
                    showFormToSetFaceName = false
                } actionCreate: {
                    // save name
                    viewModel.createNewFace { succeeded in
                        newFaceName = ""
                        // close this form
                        showFormToSetFaceName = false
                    } actionAfter: { succeeded, newFace in
                        // highlight the face has just been created?
                    }
                }

            }
        }
        .navigationTitle("FaceNote")
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $viewModel.newFaceImage)
        }
        .onChange(of: viewModel.newFaceImage) { _ in
            withAnimation(.easeIn(duration: 0.3)) {
                showFormToSetFaceName = true
            }
        }
        .padding(.horizontal, 10)
    }
}
