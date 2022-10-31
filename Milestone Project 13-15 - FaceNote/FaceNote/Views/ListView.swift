//
//  ListView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

enum ScreenFlow {
    case viewFaceList, setFaceName, viewFaceDetail, viewFilterPanel
}

struct ListView: View {
    @State private var showingImagePicker = false
    @State private var screenFlow = ScreenFlow.viewFaceList
    @State private var newFaceName = ""
    @State private var tappedFace: Face?
    
    @State private var filterKeyword = ""
    @State private var sortOrder = SortOrder.forward
    @State private var showFilterPanel = false
    @State private var resizeResultList = false
    
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
    
    private func resizeFaceList() {
        if showFilterPanel {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                resizeResultList = true
            }
        } else {
            resizeResultList = false
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                FaceList(faces: $viewModel.faces, geometry: geometry, tapOnAFaceAction: viewFaceDetail)
                    .onChange(of: viewModel.keyword) { _ in
                        viewModel.filteredFaces()
                    }
                    .onChange(of: viewModel.sortOrder) { _ in
                        viewModel.filteredFaces()
                    }
                
                Spacer(minLength: resizeResultList ? geometry.size.height * 0.23 : 0)
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
            case .viewFilterPanel:
                VStack {
                    Spacer()
                    FilterPanelView(
                        filterKeyword: $viewModel.keyword,
                        sortOrder: $viewModel.sortOrder,
                        showFilterPanel: $showFilterPanel,
                        geometry: geometry
                    )
                }
            }
        }
        .navigationTitle("FaceNote")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Filter") {
                    screenFlow = .viewFilterPanel
                    withAnimation {
                        showFilterPanel.toggle()
                    }
                    
                    resizeFaceList()
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $viewModel.newFaceImage)
        }
        .onChange(of: viewModel.newFaceImage) { _ in
            withAnimation(.easeIn(duration: 0.3)) {
                screenFlow = .setFaceName
            }
        }
        .onChange(of: screenFlow, perform: { newValue in
            if newValue != .viewFilterPanel {
                if showFilterPanel {
                    showFilterPanel.toggle()
                    resizeFaceList()
                }
            }
        })
        .padding(.horizontal, 10)
    }
}
