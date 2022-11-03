//
//  ListView-ViewModel.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import UIKit

extension ListView {
    @MainActor class ViewModel: ObservableObject {
        @Published var faces = [Face]()
        @Published var tappedFace: Face?
        @Published var newFaceImage: UIImage?
        @Published var keyword: String = ""
        @Published var sortOrder = SortOrder.forward
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
    }
}
