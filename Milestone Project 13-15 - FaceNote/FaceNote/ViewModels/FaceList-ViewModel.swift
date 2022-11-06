//
//  ListView-ViewModel.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import UIKit
import SwiftUI

enum ScreenFlow {
    case viewNothing, createFaceName, editFaceName, viewFaceDetail
}

@MainActor class FaceList: ObservableObject {
    @Published var showDeleteOption = false
    @Published var showingImagePicker = false
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
    
    func deleteFace(action: @escaping (Bool, [Face]) -> Void) {
        guard let tappedFace = tappedFace else {
            action(false, faces)
            return
        }
        
        dataController.deleteFace(tappedFace) { succeeded, faces in
            action(succeeded, faces)
        }
    }
    
    func deleteFace(face: Face, action: @escaping (Bool, [Face]) -> Void) {
        dataController.deleteFace(face) { succeeded, faces in
            action(succeeded, faces)
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
    
    func backgroundUIImage(uiImage: UIImage?) -> UIImage {
        if let newImage = uiImage {
            let thumbnailSize = CGSize(width: 200, height: 200)
            return newImage.preparingThumbnail(of: thumbnailSize) ?? UIImage()
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
    
    func mainUIImage(geometry: GeometryProxy, uiImage: UIImage?) -> UIImage {
        guard
            let newImage = uiImage
        else {
            return UIImage()
        }
        
        let newSize = CGSize(width: geometry.size.width * 0.9
        , height: geometry.size.width * 0.9)

        return newImage.preparingThumbnail(of: newSize) ?? UIImage()
    }
    
    func isFaceNameValid(name: String) -> Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func cancelAction() {
        screenFlow = .viewNothing
    }
    
    func updateFaceDone(isSucceeded: Bool) {
        if isSucceeded {
            refreshFaceList()
        }
        
        screenFlow = .viewNothing
    }
    
    func save(actionType: ActionType, faceName: String) {
        switch actionType {
        case .create:
            guard let newFaceImage = newFaceImage else { return }
            dataController.createNewFace(uiImage: newFaceImage, name: faceName) { isSucceeded, newFace in
                self.updateFaceDone(isSucceeded: isSucceeded)
            }
        case .update:
            guard let existingFace = tappedFace else { return }
            dataController.renameFace(existingFace, newName: faceName) { isSucceeded, updatedFace in
                self.updateFaceDone(isSucceeded: isSucceeded)
            }
        }
    }

}
