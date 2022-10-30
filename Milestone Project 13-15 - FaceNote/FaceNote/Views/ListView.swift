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
    //@State private var inputImage: UIImage?
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
                UpdateFaceNameView(geometry: geometry, newFaceImage: viewModel.wrappedNewFaceImage, newFaceName: $viewModel.newFaceName) {
                    // save name
                    // close this form
                    print("start canceling the form for new face")
                    showFormToSetFaceName = false
                    print("cancelled")
                } actionCreate: {
                    // save name
                    viewModel.createNewFace { succeeded in
                        newFaceName = ""
                        print("start closing the form for new face")
                        // close this form
                        showFormToSetFaceName = false
                        print("close the form for new face")
                    } actionAfter: { succeeded, newFace in
                        print("update new face \(newFace?.name)")
                    }
                }

            }
        }
        .navigationTitle("FaceNote")
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $viewModel.newFaceImage)
        }
        .onChange(of: viewModel.newFaceImage) { _ in
            showFormToSetFaceName = true
        }
    }
}
