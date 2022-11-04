//
//  ListView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ViewModel()

    var geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: viewModel.isFaceListResized ? geometry.size.height * viewModel.filterPanelHeightRatio : 0)
                
                FaceList(
                    faces: $viewModel.faces,
                    showDeleteOption: $viewModel.showDeleteOption,
                    geometry: geometry,
                    needToRefreshFaceList: $viewModel.needToRefreshFaceList,
                    showDetailAction: viewModel.showFaceDetail,
                    showEditNameAction: viewModel.showEditNameView
                )
                .onChange(of: viewModel.keyword) { _ in
                    viewModel.filteredFaces()
                }
                .onChange(of: viewModel.sortOrder) { _ in
                    viewModel.filteredFaces()
                }
                .onChange(of: viewModel.needToRefreshFaceList) { _ in
                    viewModel.refreshFaceList()
                }
                .onTapGesture {
                    viewModel.switchDeleteOptionOnEveryFace(newState: false)
                }
                .onLongPressGesture(minimumDuration: 1, perform: {
                    viewModel.switchDeleteOptionOnEveryFace(newState: true)
                })
                .onChange(of: viewModel.newFaceImage) { _ in
                    withAnimation(.easeIn(duration: 0.3)) {
                        viewModel.screenFlow = .setFaceName
                    }
                }
                .onChange(of: viewModel.screenFlow, perform: { newValue in
                    viewModel.closeFilterPanel(newScreen: newValue)
                })
                .animation(.easeIn(duration: viewModel.filterPanelAnimationDuration - 0.1), value: viewModel.isFaceListResized)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        CircleButton(imageSystemName: "magnifyingglass", font: Font.caption2) {
                            viewModel.screenFlow = .viewFilterPanel
                            withAnimation {
                                viewModel.showFilterPanel.toggle()
                            }
                            
                            viewModel.resizeFaceList()
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
                        viewModel.needToRefreshFaceList.toggle()
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
                            viewModel.needToRefreshFaceList.toggle()
                        }
                        
                        viewModel.screenFlow = .viewNothing
                    }
                }
            case .viewFaceDetail:
                if let newTappedFace = viewModel.tappedFace {
                    FaceDetailView(
                        face: newTappedFace,
                        geometry: geometry,
                        tapOnAFaceDetailAction: viewModel.closeFaceDetailAction)
                }
            case .viewFilterPanel:
                VStack {
                    FilterPanelView(
                        filterKeyword: $viewModel.keyword,
                        sortOrder: $viewModel.sortOrder,
                        showFilterPanel: $viewModel.showFilterPanel,
                        geometry: geometry,
                        filterPanelHeightRatio: viewModel.filterPanelHeightRatio,
                        animationDuration: viewModel.filterPanelAnimationDuration
                    )
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.newFaceImage)
        }
    }
}
