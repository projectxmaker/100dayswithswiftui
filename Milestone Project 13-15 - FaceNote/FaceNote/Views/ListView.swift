//
//  ListView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

struct ListView: View {
    @StateObject var faceList = FaceList()

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
                                faceList.showingImagePicker.toggle()
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
                SetFaceNameView(actionType: .create, geometry: geometry)
            case .editFaceName:
                SetFaceNameView(actionType: .update, geometry: geometry)
            case .viewFaceDetail:
                FaceDetailView(geometry: geometry)
            }
        }
        .sheet(isPresented: $faceList.showingImagePicker) {
            ImagePicker(image: $faceList.newFaceImage)
        }
        .onChange(of: faceList.newFaceImage) { _ in
            withAnimation(.easeIn(duration: 0.5)) {
                faceList.screenFlow = .createFaceName
            }
        }
        .environmentObject(faceList)
    }
}
