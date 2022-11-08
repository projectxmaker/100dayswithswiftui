//
//  ListView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI
import MapKit

struct ListView: View {
    @StateObject var faceList = FaceList()
    @StateObject var setFaceInfoVM = SetFaceInfoViewModel()

    var geometry: GeometryProxy
    
    let listVGridColumns: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ZStack {
            // MARK: - Face List
            VStack {
                Spacer(minLength: faceList.isFaceListResized ? geometry.size.height * faceList.filterPanelHeightRatio : 0)
                
                ScrollView {
                    LazyVGrid(columns: listVGridColumns, spacing: 30) {
                        ForEach($faceList.faces) { face in
                            FaceView(
                                face: face
                            )
                        }
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 10)
                }
                .animation(.linear, value: faceList.faces)
                .onTapGesture {
                    faceList.switchDeleteOptionOnEveryFace(newState: false)
                }
                .onLongPressGesture(minimumDuration: 1, perform: {
                    faceList.switchDeleteOptionOnEveryFace(newState: true)
                })
                .animation(.easeIn(duration: faceList.filterPanelAnimationDuration - 0.1), value: faceList.isFaceListResized)
            }
            
            // MARK: - Buttons
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        CircleButton(imageSystemName: "magnifyingglass", font: Font.caption2) {
                            faceList.openFilterPanel()
                        }
                        
                        CircleButton(imageSystemName: "plus") {
                            faceList.closeFilterPanel()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                setFaceInfoVM.isImagePickerForNewFaceShowed.toggle()
                            }
                        }
                    }
                    
                }
            }
            
            // MARK: - Filter
            VStack {
                FilterPanelView(
                    filterKeyword: $faceList.keyword,
                    sortOrder: $faceList.sortOrder,
                    isFilterPanelShowed: faceList.isFilterPanelShowed,
                    geometry: geometry,
                    filterPanelHeightRatio: faceList.filterPanelHeightRatio,
                    filterPanelAnimationDuration: faceList.filterPanelAnimationDuration
                )
                Spacer()
            }
            
            // MARK: - Set/Edit Face Name
            switch faceList.screenFlow {
            case .viewNothing:
                Text("")
                    .hidden()
            case .createFaceName:
                CreateFaceView(geometry: geometry)
            case .editFaceName:
                if let tappedFace = faceList.tappedFace {
                    RenameFaceView(geometry: geometry, face: tappedFace)
                }
            case .changeFace:
                if let tappedFace = faceList.tappedFace {
                    ChangeFaceInfoView(geometry: geometry, face: tappedFace)
                }
            case .viewFaceDetail:
                FaceDetailView(geometry: geometry)
            case .showMap:
                FaceLocationMapView(
                    isSmallSizeShowed: false,
                    actionToExitFullscreen: {
                        faceList.screenFlow = .viewFaceDetail
                    },
                    actionToExit: {
                        faceList.screenFlow = .viewNothing
                    }
                )
                .ignoresSafeArea()
            }
        }
        .padding(Edge.Set.horizontal, 17)
        .sheet(isPresented: $setFaceInfoVM.isImagePickerForNewFaceShowed) {
            ImagePicker(image: $setFaceInfoVM.newFaceImage)
        }
        .onChange(of: setFaceInfoVM.newFaceImage) { _ in
            withAnimation(.easeIn(duration: 0.5)) {
                faceList.screenFlow = .createFaceName
            }
        }
        .sheet(isPresented: $faceList.isChangeImageShowed) {
            ImagePicker(image: $setFaceInfoVM.changeNewFaceImage)
        }
        .onChange(of: setFaceInfoVM.changeNewFaceImage) { _ in
            withAnimation(.easeIn(duration: 0.5)) {
                faceList.screenFlow = .changeFace
            }
        }
        .environmentObject(faceList)
        .environmentObject(setFaceInfoVM)
    }
}
