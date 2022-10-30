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

extension URL {
    func loadImage(_ image: inout UIImage?) {
        if let data = try? Data(contentsOf: self), let loaded = UIImage(data: data) {
            image = loaded
        } else {
            image = nil
        }
    }
    func saveImage(_ image: UIImage?) {
        if let image = image {
            if let data = image.jpegData(compressionQuality: 1.0) {
                try? data.write(to: self)
            }
        } else {
            try? FileManager.default.removeItem(at: self)
        }
    }
}

struct ListView: View {
    @State private var sceneFlow = SceneFlow.list
    @State private var showingImagePicker = false
    @State private var showFormToSetFaceName = false
    //@State private var inputImage: UIImage?
    @FocusState private var isTextFieldNameFocused: Bool
    
    var geometry: GeometryProxy
    var imageOfNameForm: Image {
        if let newImage = viewModel.newFaceImage {
            return Image(uiImage: newImage)
        } else {
            return Image(systemName: "person")
        }
    }
    
    @StateObject private var viewModel = ViewModel()
    
    let listVGridColumns: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ZStack {
            switch sceneFlow {
            case .list:
                ScrollView {
                    LazyVGrid(columns: listVGridColumns) {
                        ForEach(viewModel.faces) { face in
                            VStack {
                                if let data = try? Data(contentsOf: FileManager.default.getDocumentsDirectory().appendingPathComponent(face.id.uuidString)), let loaded = UIImage(data: data) {
                                    Image(uiImage: loaded)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: 100, maxHeight: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .shadow(color: .gray, radius: 10, x: 1, y: 1)
                                    
                                }
                                Text(face.name)
                            }
                        }
                    }
                }
                
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
            case .askForFaceName:
                VStack(spacing: 0) {
                    imageOfNameForm
                        .resizable()
                        .scaledToFill()
                        .padding(1)
                        .background(Color.white)
                        .frame(maxWidth: geometry.size.width * 0.4, maxHeight: geometry.size.height * 0.25)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray, radius: 10, x: 1, y: 1)
                    
                    TextField(text: $viewModel.newFaceName, prompt: Text("Enter name here")) {
                        Text("Name")
                    }
                    .focused($isTextFieldNameFocused)
                    .padding(15)
                    .background(.white)
                    .frame(maxWidth: geometry.size.width * 0.6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray, radius: 5, x: 1, y: 1)
                    .onAppear {
                        isTextFieldNameFocused.toggle()
                    }

                    HStack {
                        Button("Cancel", role: .cancel) {
                            // save name
                            // close this form
                            sceneFlow = .list
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            // save name
                            viewModel.createNewFace { result, newFace in
                                
                                print("create new face \(result)")
                                // close this form
                                sceneFlow = .list
                            }
                        } label: {
                            Text("Create")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding([.top], 20)

                }
            }
        }
        .navigationTitle("FaceNote")
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $viewModel.newFaceImage)
        }
        .onChange(of: viewModel.newFaceImage) { _ in
            sceneFlow = .askForFaceName
        }
    }
}
