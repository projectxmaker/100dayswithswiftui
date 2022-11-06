//
//  ListView-ViewModel.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import UIKit
import SwiftUI

enum ScreenFlow {
    case viewNothing, setFaceName, editFaceName, viewFaceDetail
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
    
    var wrappedNewFaceImage: UIImage {
        newFaceImage ?? UIImage()
    }
    
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
    
    func backgroundUIImage() -> UIImage {
        if let face = self.tappedFace {
            let backgroundImageURL = FileManager.default.getFileURL(fileName: face.thumbnail)
            return UIImage.getUIImage(url: backgroundImageURL) ?? UIImage()
        } else {
            return UIImage()
        }
    }
    
    func mainUIImage(geometry: GeometryProxy) -> UIImage {
        guard
            let face = self.tappedFace
        else {
            return UIImage()
        }
        
        let newSize = CGSize(width: geometry.size.width * 0.9
        , height: geometry.size.width * 0.9)

        let mainImageURL = FileManager.default.getFileURL(fileName: face.picture)
        return UIImage.getUIImage(url: mainImageURL, size: newSize) ?? UIImage()
    }
}
