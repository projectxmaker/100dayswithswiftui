//
//  ListView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

enum ScreenFlow {
    case viewFaceList, setFaceName, viewFaceDetail
}

struct ListView: View {
    @State private var showingImagePicker = false
    @State private var screenFlow = ScreenFlow.viewFaceList
    @State private var newFaceName = ""
    @State private var tappedFace: Face?
    @StateObject private var viewModel = ViewModel()
    @FocusState private var isTextFieldNameFocused: Bool
    
    var geometry: GeometryProxy
    
    private func viewFaceDetail(face: Face) {
        tappedFace = face
        screenFlow = .viewFaceDetail
    }
    
    private func closeFaceDetailAction() {
        screenFlow = .viewFaceList
    }
    
    var body: some View {
        ZStack {
            FaceList(faces: $viewModel.faces, geometry: geometry, tapOnAFaceAction: viewFaceDetail)
            
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
            
            switch screenFlow {
            case .viewFaceList:
                Text("")
            case .setFaceName:
                Color.white
                    .opacity(0.8)
                    .onTapGesture {
                        screenFlow = .viewFaceList
                    }

                UpdateFaceNameView(geometry: geometry, newFaceImage: viewModel.wrappedNewFaceImage, newFaceName: $viewModel.newFaceName) {
                    // save name
                    // close this form
                    screenFlow = .viewFaceList
                } actionCreate: {
                    // save name
                    viewModel.createNewFace { succeeded in
                        newFaceName = ""
                        // close this form
                        screenFlow = .viewFaceList
                    } actionAfter: { succeeded, newFace in
                        // highlight the face has just been created?
                    }
                }
            case .viewFaceDetail:
                if let tappedFace = tappedFace {
                    FaceDetailView(
                        backgrounUIImageURL: FileManager.default.getDocumentsDirectory().appendingPathComponent(tappedFace.thumbnail),
                        mainUIImageURL: FileManager.default.getDocumentsDirectory().appendingPathComponent(tappedFace.picture),
                        label: tappedFace.name,
                        geometry: geometry,
                        tapOnAFaceDetailAction: closeFaceDetailAction)
                }
            }
        }
        .navigationTitle("FaceNote")
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $viewModel.newFaceImage)
        }
        .onChange(of: viewModel.newFaceImage) { _ in
            withAnimation(.easeIn(duration: 0.3)) {
                screenFlow = .setFaceName
            }
        }
        .padding(.horizontal, 10)
    }
}
