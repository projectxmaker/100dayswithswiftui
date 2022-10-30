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
    //@State private var inputImage: UIImage?
    @FocusState private var isTextFieldNameFocused: Bool
    @State private var newFaceName = ""
    
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
                            if face.picture.isEmpty {
                                ProgressView()
                                    .frame(maxWidth: 100, maxHeight: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: .gray, radius: 10, x: 1, y: 1)
                            } else {
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
                    
                    TextField(text: $newFaceName, prompt: Text("Enter name here")) {
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
                    .onChange(of: newFaceName) { newValue in
                        viewModel.newFaceName = newValue
                    }

                    HStack {
                        Button("Cancel", role: .cancel) {
                            // save name
                            // close this form
                            sceneFlow = .list
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            sceneFlow = .list
//                            // save name
//                            viewModel.createNewFace { succeeded in
//                                newFaceName = ""
//                                print("start closing the form for new face")
//                                // close this form
//                                sceneFlow = .list
//                                print("close the form for new face")
//                            } actionAfter: { succeeded, newFace in
//                                print("update new face \(newFace?.name)")
//                            }
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
