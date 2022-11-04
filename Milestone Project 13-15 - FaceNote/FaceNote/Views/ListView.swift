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
    enum CurrentAction {
        case list
    }
    
    @State private var currentAction = CurrentAction.list
    
    @State private var longPressOnFaceList = false
    @State private var tapOnFaceList = false
    
    @State private var longPressOnFace = false
    @State private var showDeleteOption = false
    @State private var showingImagePicker = false
    @State private var screenFlow = ScreenFlow.viewNothing
    @State private var tappedFace: Face?
    @State private var showFilterPanel = false
    @State private var resizeResultList = false
    @State private var refreshTheList = false
    
    @StateObject private var viewModel = ViewModel()
    @FocusState private var isTextFieldNameFocused: Bool
    
    private let filterPanelHeightRatio = 0.06
    private let filterPanelAnimationDuration = 0.5
    
    var geometry: GeometryProxy
    
    private func viewFaceDetail(face: Face) {
        tappedFace = face
        screenFlow = .viewFaceDetail
    }
    
    private func showEditNameView(face: Face) {
        tappedFace = face
        screenFlow = .editFaceName
    }
    
    private func hideDeleteOptionOnEveryFace() {
        print("current action \(currentAction)")
        if (showDeleteOption) {
            print("hide all deletions")
            showDeleteOption = false
        }
    }
    
    private func longPressToEnableDeleteOptionOnEveryFace() {
        print("long press on face \(longPressOnFace)")
        if (!showDeleteOption) {
            if !longPressOnFace {
                showDeleteOption = true
            }
        } else {
            showDeleteOption = false
        }
    }
    
    private func closeFaceDetailAction() {
        screenFlow = .viewNothing
    }
    
    private func resizeFaceList() {
        let animationDuration = filterPanelAnimationDuration - 0.1
            if showFilterPanel {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.easeIn(duration: animationDuration)) {
                        resizeResultList = true
                    }
                }
            } else {
                withAnimation(.easeIn(duration: animationDuration)) {
                    resizeResultList = false
                }
            }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: resizeResultList ? geometry.size.height * filterPanelHeightRatio : 0)
                
                FaceList(faces: $viewModel.faces, showDeleteOption: $showDeleteOption, geometry: geometry,
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
                .onChange(of: tappedFace) { newValue in
                    viewModel.tappedFace = newValue
                }
                .gesture(TapGesture(count: 1)
                    .onEnded({ void in
                        print("tap on face list 2")
                        tapOnFaceList.toggle()
                    })
                )
                
            }
            .gesture(LongPressGesture(minimumDuration: 1).onEnded({ value in
                print("long press on face list")
                longPressOnFaceList.toggle()
            }))
//            .gesture(TapGesture(count: 1)
//                .onEnded({ void in
//                    print("tap on face list")
//                    tapOnFaceList.toggle()
//                })
//            )
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        CircleButton(imageSystemName: "magnifyingglass", font: Font.caption2) {
                            screenFlow = .viewFilterPanel
                            withAnimation {
                                showFilterPanel.toggle()
                            }
                            
                            resizeFaceList()
                        }
                        
                        CircleButton(imageSystemName: "plus") {
                            showingImagePicker = true
                        }
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
                if showFilterPanel {                        showFilterPanel.toggle()
                    resizeFaceList()
                }
            }
        })
        .onChange(of: longPressOnFaceList, perform: { newValue in
            print("long press on screen CHANGED")
            longPressToEnableDeleteOptionOnEveryFace()
        })
        
        .onChange(of: tapOnFaceList, perform: { newValue in
            // wait for update of Delete A Face from FaceView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                hideDeleteOptionOnEveryFace()
            }
        })        
    }
}
