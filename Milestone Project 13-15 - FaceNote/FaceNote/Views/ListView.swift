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
    
    let listVGridColumns: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ZStack {
            Image("universal")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .blendMode(.luminosity)
            
            // MARK: - Face List
            VStack {
                Spacer(minLength: viewModel.isFaceListResized ? geometry.size.height * viewModel.filterPanelHeightRatio : 0)
                
                ScrollView {
                    LazyVGrid(columns: listVGridColumns) {
                        ForEach($viewModel.faces) { face in
                            FaceView(
                                face: face,
                                needToRefreshFaceList: $viewModel.needToRefreshFaceList,
                                showDeleteOption: $viewModel.showDeleteOption,
                                showDetailAction: viewModel.showFaceDetail,
                                showEditNameAction: viewModel.showEditNameView
                            )
                        }
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 10)
                }
                .animation(.linear, value: viewModel.faces)
                .onTapGesture {
                    viewModel.switchDeleteOptionOnEveryFace(newState: false)
                }
                .onLongPressGesture(minimumDuration: 1, perform: {
                    viewModel.switchDeleteOptionOnEveryFace(newState: true)
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
                Text("")
                    .hidden()
            case .setFaceName:
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
        .environmentObject(viewModel)
    }
}
