//
//  ListView-ViewModel.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import UIKit
import SwiftUI

enum ScreenFlow {
    case viewNothing, createFaceName, editFaceName, viewFaceDetail, changeFace, showMap
}

@MainActor class FaceList: ObservableObject {
    @Published var showDeleteOption = false
    @Published var isChangeImageShowed = false
    @Published var screenFlow = ScreenFlow.viewNothing {
        didSet {
            closeFilterPanel()
        }
    }
    
    @Published var isFilterPanelShowed = false
    
    @Published var isFaceListResized = false
    let filterPanelHeightRatio = 0.06
    let filterPanelAnimationDuration = 0.5
    
    @Published var faces = [Face]()
    @Published var tappedFace: Face?
    @Published var newFaceImage: UIImage?
    @Published var changeNewFaceImage: UIImage?
    @Published var keyword: String = "" {
        didSet {
            filteredFaces()
        }
    }
    
    @Published var sortOrder = SortOrder.forward {
        didSet {
            filteredFaces()
        }
    }
    
    @Published var modifiedFace: Face?
    
    private var dataController = DataController.shared
    
    var deleteMessage: String {
        guard let tappedFace = tappedFace else { return "Unknown Face"}
        
        return "Delete \"\(tappedFace.name)\"\nTap Delete to confirm."
    }
    
    init() {
        filteredFaces()
    }
    
    func filteredFaces() {
        faces = dataController.filteredFaces(keyword: keyword, sortOrder: sortOrder)
    }
    
    func refreshFaceList() {
        modifiedFace = dataController.modifiedFace
        filteredFaces()
    }
    
    func deleteFace(action: ((Bool, [Face]) -> Void)? = nil) {
        guard let tappedFace = tappedFace else {
            if let action = action {
                action(false, faces)
            }
            return
        }
        
        dataController.deleteFace(tappedFace) { succeeded, faces in
            // if there's no items and feature attaching deletion option on each Face is being used, turn this feature off.
            if faces.isEmpty && self.showDeleteOption {
                self.showDeleteOption.toggle()
            }
            
            self.refreshFaceList()
                
            if let action = action {
                action(succeeded, faces)
            }
        }
    }

    func switchDeleteOptionOnEveryFace(newState: Bool) {
        if newState {
            if !showDeleteOption {
                showDeleteOption = true
            }
        } else if showDeleteOption {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.showDeleteOption = false
            }
        }
    }
    
    func resizeFaceList() {
        if isFilterPanelShowed {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.isFaceListResized = true
            }
        } else {
            isFaceListResized = false
        }
    }
    
    func showFaceDetail(face: Face) {
        tappedFace = face
        screenFlow = .viewFaceDetail
    }
    
    func showEditNameView(face: Face) {
        tappedFace = face
        screenFlow = .editFaceName
    }
    
    func openImagePickerToChangeImage(face: Face) {
        tappedFace = face
        isChangeImageShowed.toggle()
    }
    
    func closeFaceDetailAction() -> Void {
        screenFlow = .viewNothing
    }
    
    func closeFilterPanel() {
        if isFilterPanelShowed {
            isFilterPanelShowed.toggle()
            resizeFaceList()
        }
    }
    
    func openFilterPanel() {
        isFilterPanelShowed.toggle()
        resizeFaceList()
    }
    
    func backgroundUIImage(face: Face?) -> UIImage {
        if let face = face {
            let backgroundImageURL = FileManager.default.getFileURL(fileName: face.thumbnail)
            return UIImage.getUIImage(url: backgroundImageURL) ?? UIImage()
        } else {
            return UIImage()
        }
    }

    func mainUIImage(geometry: GeometryProxy, face: Face?) -> UIImage {
        guard
            let face = face
        else {
            return UIImage()
        }
        
        let newSize = CGSize(width: geometry.size.width * 0.9
        , height: geometry.size.width * 0.9)

        let mainImageURL = FileManager.default.getFileURL(fileName: face.picture)
        return UIImage.getUIImage(url: mainImageURL, size: newSize) ?? UIImage()
    }

    func cancelAction() {
        screenFlow = .viewNothing
    }
    
    func updateFaceDone(_ isSucceeded: Bool) {
        if isSucceeded {
            refreshFaceList()
        }
        
        screenFlow = .viewNothing
    }

    func openFaceLocationMap() {
        screenFlow = .showMap
    }
}
