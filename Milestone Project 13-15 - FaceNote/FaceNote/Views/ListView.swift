//
//  ListView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

enum ScreenFlow {
    case viewNothing, setFaceName, editFaceName, viewFaceDetail, viewFilterPanel
}

struct ListView: View {
    @State private var showingImagePicker = false
    @State private var screenFlow = ScreenFlow.viewNothing
    @State private var tappedFace: Face?
    @State private var showFilterPanel = false
    @State private var resizeResultList = false
    @State private var refreshTheList = false
    
    @StateObject private var viewModel = ViewModel()
    @FocusState private var isTextFieldNameFocused: Bool
    
    var geometry: GeometryProxy
    
    private func viewFaceDetail(face: Face) {
        tappedFace = face
        screenFlow = .viewFaceDetail
    }
    
    private func showEditNameView(face: Face) {
        tappedFace = face
        screenFlow = .editFaceName
    }
    
    private func showDeleteView(face: Face) {
        screenFlow = .viewFaceDetail
    }
    
    private func closeFaceDetailAction() {
        screenFlow = .viewNothing
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
                FaceList(faces: $viewModel.faces, geometry: geometry, tapOnAFaceAction: viewFaceDetail,
                    showEditNameAction: showEditNameView,
                    showDeleteAction: showDeleteView
                )
                .onChange(of: viewModel.keyword) { _ in
                    viewModel.filteredFaces()
                }
                .onChange(of: viewModel.sortOrder) { _ in
                    viewModel.filteredFaces()
                }
                .onChange(of: refreshTheList) { _ in
                    viewModel.refreshFaceList()
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
            case .viewNothing:
                Text("")
            case .setFaceName:
                Color.white
                    .opacity(0.8)
                    .onTapGesture {
                        screenFlow = .viewNothing
                    }
                
                EditFaceNameView(geometry: geometry, newFaceImage: viewModel.wrappedNewFaceImage) {
                    // save name
                    // close this form
                    screenFlow = .viewNothing
                } actionSave: { actionType, isSucceeded, newFace in
                    if isSucceeded {
                        refreshTheList.toggle()
                    }
                    
                    screenFlow = .viewNothing
                }
            case .editFaceName:
                if let tappedFace = tappedFace {
                    Color.white
                        .opacity(0.8)
                        .onTapGesture {
                            screenFlow = .viewNothing
                        }
                    
                    EditFaceNameView(geometry: geometry, face: tappedFace) {
                        // save name
                        // close this form
                        screenFlow = .viewNothing
                    } actionSave: { actionType, isSucceeded, updatedFace in
                        if isSucceeded {
                            refreshTheList.toggle()
                        }
                        
                        screenFlow = .viewNothing
                    }
                }
            case .viewFaceDetail:
                if let newTappedFace = tappedFace {
                    FaceDetailView(
                        face: newTappedFace,
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
