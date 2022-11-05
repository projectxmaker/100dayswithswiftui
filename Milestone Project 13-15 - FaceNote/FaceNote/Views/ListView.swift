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
            // MARK: - Face List
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
                .onTapGesture {
                    viewModel.switchDeleteOptionOnEveryFace(newState: false)
                }
                .onLongPressGesture(minimumDuration: 1, perform: {
                    viewModel.switchDeleteOptionOnEveryFace(newState: true)
                })
                .onChange(of: viewModel.screenFlow, perform: { newValue in
                    viewModel.closeFilterPanel()
                })
                .animation(.easeIn(duration: viewModel.filterPanelAnimationDuration - 0.1), value: viewModel.isFaceListResized)
            }
            
            // MARK: - Buttons
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        CircleButton(imageSystemName: "magnifyingglass", font: Font.caption2) {
                            viewModel.openFilterPanel()
                        }
                        
                        CircleButton(imageSystemName: "plus") {
                            viewModel.closeFilterPanel()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                viewModel.showingImagePicker.toggle()
                            }
                        }
                    }
                    
                }
            }
            
            // MARK: - Filter
            VStack {
                FilterPanelView(
                    filterKeyword: $viewModel.keyword,
                    sortOrder: $viewModel.sortOrder,
                    isFilterPanelShowed: viewModel.isFilterPanelShowed,
                    geometry: geometry,
                    filterPanelHeightRatio: viewModel.filterPanelHeightRatio,
                    filterPanelAnimationDuration: viewModel.filterPanelAnimationDuration
                )
                Spacer()
            }
            
            // MARK: - Set/Edit Face Name
            switch viewModel.screenFlow {
            case .viewNothing:
                Text("XXXXX")
                    .hidden()
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
            }
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.newFaceImage)
        }
        .onChange(of: viewModel.newFaceImage) { _ in
            withAnimation(.easeIn(duration: 0.5)) {
                viewModel.screenFlow = .setFaceName
            }
        }
    }
}
