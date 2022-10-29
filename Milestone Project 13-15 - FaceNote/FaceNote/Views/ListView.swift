//
//  ListView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

enum SceneFlow {
    case list, askForFaceName
}

struct ListView: View {
    @State private var sceneFlow = SceneFlow.list
    @State private var showingImagePicker = false
    @State private var showFormToSetFaceName = false
    @State private var inputImage: UIImage?
    @FocusState private var isTextFieldNameFocused: Bool
    
    var geometry: GeometryProxy
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            switch sceneFlow {
            case .list:
                List {
                    ForEach(viewModel.faces) { face in
                        HStack {
                            Image(systemName: "person")
                            Text(face.name)
                        }
                    }
                }
            case .askForFaceName:
                VStack {
                    Spacer()
                    TextField(text: $viewModel.newFaceName, prompt: Text("Enter name here")) {
                        Text("Name")
                    }
                    .focused($isTextFieldNameFocused)
                    .padding()
                    .background(.white)
                    .frame(maxWidth: geometry.size.width * 0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray, radius: 10, x: 1, y: 1)
                    .onAppear {
                        isTextFieldNameFocused.toggle()
                    }
                    Spacer()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingImagePicker = true
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
        .navigationTitle("FaceNote")
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in
            // get image path?
            // viewModel.newFace = Face(id: UUID(), name: "", picture: "")
            print("changed")
            sceneFlow = .askForFaceName
        }
    }
}
