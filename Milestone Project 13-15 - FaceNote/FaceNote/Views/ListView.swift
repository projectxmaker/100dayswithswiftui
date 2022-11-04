//
//  ListView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ViewModel()

    @State private var showFilterPanel = false
    @State private var isFaceListResized = false
    @State private var refreshTheList = false
    
    private let filterPanelHeightRatio = 0.06
    private let filterPanelAnimationDuration = 0.5
    
    var geometry: GeometryProxy
    
    private func viewFaceDetail(face: Face) {
        viewModel.tappedFace = face
        viewModel.screenFlow = .viewFaceDetail
    }
    
    private func showEditNameView(face: Face) {
        viewModel.tappedFace = face
        viewModel.screenFlow = .editFaceName
    }
    
    private func hideDeleteOptionOnEveryFace() {
        if (viewModel.showDeleteOption) {
            print("hide all deletions")
            viewModel.showDeleteOption = false
        }
    }
    
    private func closeFaceDetailAction() {
        viewModel.screenFlow = .viewNothing
    }
    
    private func resizeFaceList() {
        if showFilterPanel {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                isFaceListResized = true
            }
        } else {
            isFaceListResized = false
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: isFaceListResized ? geometry.size.height * filterPanelHeightRatio : 0)
                
                FaceList(
                    faces: $viewModel.faces,
                    showDeleteOption: $viewModel.showDeleteOption,
                    geometry: geometry,
                    refreshTheList: $refreshTheList,
                    showDetailAction: viewFaceDetail,
                    showEditNameAction: showEditNameView
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
//                .onChange(of: tappedFace) { newValue in
//                    viewModel.tappedFace = newValue
//                }
                .onTapGesture {
                    viewModel.switchDeleteOptionOnEveryFace(newState: false)
                }
                .onLongPressGesture(minimumDuration: 1, perform: {
                    viewModel.switchDeleteOptionOnEveryFace(newState: true)
                })
                .animation(.easeIn(duration: filterPanelAnimationDuration - 0.1), value: isFaceListResized)
                //.animation(.easeIn, value: showFilterPanel)
                
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        CircleButton(imageSystemName: "magnifyingglass", font: Font.caption2) {
                            viewModel.screenFlow = .viewFilterPanel
                            withAnimation {
                                showFilterPanel.toggle()
                            }
                            
                            resizeFaceList()
                        }
                        
                        CircleButton(imageSystemName: "plus") {
                            viewModel.showingImagePicker.toggle()
                        }
                    }
                    
                }
            }
            
            switch viewModel.screenFlow {
            case .viewNothing:
                Text("")
            case .setFaceName:
                Color.white
                    .opacity(0.8)
                    .onTapGesture {
                        viewModel.screenFlow = .viewNothing
                    }
                
                EditFaceNameView(geometry: geometry, newFaceImage: viewModel.wrappedNewFaceImage) {
                    // save name
                    // close this form
                    viewModel.screenFlow = .viewNothing
                } actionSave: { actionType, isSucceeded, newFace in
                    if isSucceeded {
                        refreshTheList.toggle()
                    }
                    
                    viewModel.screenFlow = .viewNothing
                }
            case .editFaceName:
                if let tappedFace = viewModel.tappedFace {
                    Color.white
                        .opacity(0.8)
                        .onTapGesture {
                            viewModel.screenFlow = .viewNothing
                        }
                    
                    EditFaceNameView(geometry: geometry, face: tappedFace) {
                        // save name
                        // close this form
                        viewModel.screenFlow = .viewNothing
                    } actionSave: { actionType, isSucceeded, updatedFace in
                        if isSucceeded {
                            refreshTheList.toggle()
                        }
                        
                        viewModel.screenFlow = .viewNothing
                    }
                }
            case .viewFaceDetail:
                if let newTappedFace = viewModel.tappedFace {
                    FaceDetailView(
                        face: newTappedFace,
                        geometry: geometry,
                        tapOnAFaceDetailAction: closeFaceDetailAction)
                }
            case .viewFilterPanel:
                VStack {
                    FilterPanelView(
                        filterKeyword: $viewModel.keyword,
                        sortOrder: $viewModel.sortOrder,
                        showFilterPanel: $showFilterPanel,
                        geometry: geometry,
                        filterPanelHeightRatio: filterPanelHeightRatio,
                        animationDuration: filterPanelAnimationDuration
                    )
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.newFaceImage)
        }
        .onChange(of: viewModel.newFaceImage) { _ in
            withAnimation(.easeIn(duration: 0.3)) {
                viewModel.screenFlow = .setFaceName
            }
        }
        .onChange(of: viewModel.screenFlow, perform: { newValue in
            if newValue != .viewFilterPanel {
                if showFilterPanel {                        showFilterPanel.toggle()
                    resizeFaceList()
                }
            }
        })
    }
}
