//
//  UpdateFaceNameView-ViewModel.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/30/22.
//

import UIKit

extension EditFaceNameView {
    @MainActor class ViewModel: ObservableObject {
        enum ActionType {
            case create, update
        }
        
        @Published var faceName: String = ""
        @Published var face: Face?
        
        private var dataController = DataController.shared
        
        var faceImage: UIImage
        var actionCancel: () -> Void
        var actionSave: (EditFaceNameView.ViewModel.ActionType, Bool, Face?) -> Void
        
        init(newFaceImage: UIImage, actionCancel: @escaping () -> Void, actionSave: @escaping (EditFaceNameView.ViewModel.ActionType, Bool, Face?) -> Void) {
            self.faceImage = newFaceImage
            self.actionCancel = actionCancel
            self.actionSave = actionSave
        }
        
        init(face: Face, actionCancel: @escaping () -> Void, actionSave: @escaping (EditFaceNameView.ViewModel.ActionType, Bool, Face?) -> Void) {
            let faceImageURL = FileManager.default.getDocumentsDirectory().appendingPathComponent(face.thumbnail)
            
            let faceImage = UIImage.getUIImage(url: faceImageURL) ?? UIImage()
            
            self.face = face
            self.faceName = face.name
            self.faceImage = faceImage
            self.actionCancel = actionCancel
            self.actionSave = actionSave
        }
        
        func isFaceNameValid() -> Bool {
            !faceName.trimmingCharacters(in: .whitespaces).isEmpty
        }
        
        func save() {
            if let face = face {
                // save
                dataController.renameFace(face, newName: faceName) { result, updatedFace in
                    actionSave(.update, result, updatedFace)
                }
            } else {
                // create new
                // create a place holder for new Face on List
                dataController.createNewFace(uiImage: faceImage, name: faceName) { succeeded, newFace in
                    self.actionSave(.create, succeeded, newFace)
                }
            }
        }
    }
}
