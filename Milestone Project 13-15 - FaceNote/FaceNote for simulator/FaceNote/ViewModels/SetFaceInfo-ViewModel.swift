//
//  CreateFace-ViewModel.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/6/22.
//

import UIKit
import SwiftUI

enum ActionType {
    case create, rename, changeFace
}

@MainActor class SetFaceInfoViewModel: ObservableObject {
    private var dataController = DataController.shared
    
    @Published var isImagePickerForNewFaceShowed = false
    
    @Published var actionType = ActionType.create
    @Published var editedFace: Face?
    @Published var newFaceImage: UIImage?
    @Published var changeNewFaceImage: UIImage?
    
    @Published var mainImage = UIImage()
    @Published var backgroundImage = UIImage()
    
    @Published var faceName = ""
    @Published var faceLatitude: Double = 0
    @Published var faceLongitude: Double = 0
    
    func backgroundUIImage(face: Face?) {
        if let face = face {
            let backgroundImageURL = FileManager.default.getFileURL(fileName: face.thumbnail)
            backgroundImage =  UIImage.getUIImage(url: backgroundImageURL) ?? UIImage()
        } else {
            backgroundImage =  UIImage()
        }
    }
    
    func backgroundUIImage(uiImage: UIImage?) {
        if let newImage = uiImage {
            let thumbnailSize = CGSize(width: 200, height: 200)
            backgroundImage =  newImage.preparingThumbnail(of: thumbnailSize) ?? UIImage()
        } else {
            backgroundImage = UIImage()
        }
    }
    
    func mainUIImage(geometry: GeometryProxy, face: Face?) {
        guard
            let face = face
        else {
            mainImage = UIImage()
            return
        }
        
        let newSize = CGSize(width: geometry.size.width * 0.9
        , height: geometry.size.width * 0.9)

        let mainImageURL = FileManager.default.getFileURL(fileName: face.picture)
        mainImage = UIImage.getUIImage(url: mainImageURL, size: newSize) ?? UIImage()
    }
    
    func mainUIImage(geometry: GeometryProxy, uiImage: UIImage?) {
        guard
            let newImage = uiImage
        else {
            mainImage = UIImage()
            return
        }
        
        let newSize = CGSize(width: geometry.size.width * 0.9
        , height: geometry.size.width * 0.9)

        mainImage = newImage.preparingThumbnail(of: newSize) ?? UIImage()
    }
    
    func isFaceNameValid() -> Bool {
        !faceName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func save(actionDone: @MainActor @escaping (Bool) -> Void) {
        switch actionType {
        case .create:
            guard let newFaceImage = newFaceImage else {
                actionDone(false)
                return
            }
            
            dataController.createNewFace(uiImage: newFaceImage, name: faceName, latitude: faceLatitude, longitude: faceLongitude) { isSucceeded, newFace in
                actionDone(isSucceeded)
            }
        case .rename:
            guard let existingFace = editedFace else {
                actionDone(false)
                return
            }
            
            dataController.renameFace(existingFace, newName: faceName) { isSucceeded, updatedFace in
                actionDone(isSucceeded)
            }
        case .changeFace:
            guard
                let existingFace = editedFace,
                let newFaceImage = changeNewFaceImage
            else {
                actionDone(false)
                return
            }
            
            dataController.changeFace(existingFace, uiImage: newFaceImage, newName: faceName, latitude: faceLatitude, longitude: faceLongitude) { isSucceeded, updatedFace in
                actionDone(isSucceeded)
            }
        }
    }
}
