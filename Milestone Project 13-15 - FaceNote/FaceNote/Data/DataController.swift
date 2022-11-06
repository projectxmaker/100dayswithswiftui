//
//  DataController.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import UIKit

class DataController {
    static var shared = DataController()
    
    let jsonFileName = "faces"
    
    var faces = [Face]()
    
    private var justModifiedFace: Face?
    
    var modifiedFace: Face? {
        justModifiedFace ?? nil
    }
    
    init() {
        if faces.isEmpty {
            _ = getFaceList()
        }
    }
    
    func getFaceList() -> [Face] {
        guard let faces = FileManager.default.decodeJSON(jsonFileName) as [Face]? else {
            return [Face]()
        }
        
        self.faces = faces
        
        return faces
    }
    
    func filteredFaces(keyword: String, sortOrder: SortOrder) -> [Face] {
        var newFaces = faces
        
        if !keyword.trimmingCharacters(in: .whitespaces).isEmpty {
            newFaces = faces.filter { face in
                face.name.lowercased().contains(keyword.lowercased())
            }
        }
        
        newFaces.sort { lhs, rhs in
            if sortOrder == .forward {
                return lhs < rhs
            } else {
                return lhs > rhs
            }
        }
        
        return newFaces
    }
    
    private func generateNewFace(uiImage: UIImage, name: String) -> Face? {
        let faceId = UUID()
        let pictureName = faceId.uuidString
        let thumbnailName = "\(pictureName)_thumbnail"
        let thumbnailSize = CGSize(width: 200, height: 200)
        
        let newFace = Face(id: faceId, name: name, picture: pictureName, thumbnail: thumbnailName)

        guard
            let _ = FileManager.default.saveUIImage(uiImage, name: pictureName),
            let thumbnailUIImage = uiImage.preparingThumbnail(of: thumbnailSize),
            let _ = FileManager.default.saveUIImage(thumbnailUIImage, name: thumbnailName)
        else {
            return nil
        }
        
        return newFace
    }
    
    func createNewFace(uiImage: UIImage, name: String, action: @escaping (Bool, Face?) -> Void) {
        guard let newFace = generateNewFace(uiImage: uiImage, name: name)
        else {
            action(false, nil)
            return
        }
            
        self.faces.insert(newFace, at: 0)

        // save JSON file into app document directory
        saveFaces { result in
            if result {
                action(true, newFace)
            } else {
                action(false, nil)
            }
        }
    }
    
    func renameFace(_ face: Face, newName: String, action: (Bool, Face?) -> Void) {
        if let index = faces.firstIndex(of: face) {
            var updatedFace = face
            updatedFace.name = newName
            updatedFace.id = UUID()
            faces[index] = updatedFace
            
            justModifiedFace = updatedFace
            
            saveFaces { result in
                action(result, updatedFace)
            }
        } else {
            action(false, nil)
        }
    }
    
    func changeFace(_ face: Face, uiImage: UIImage, newName: String, action: (Bool, Face?) -> Void) {
        guard
            let index = faces.firstIndex(of: face),
            let newFace = generateNewFace(uiImage: uiImage, name: newName)
        else {
            action(false, nil)
            return
        }
        
        faces[index] = newFace
        
        justModifiedFace = newFace
        
        saveFaces { result in
            action(result, newFace)
        }
    }
    
    func deleteFace(_ face: Face, action: @escaping (Bool, [Face]) -> Void) {
        if let index = faces.firstIndex(of: face) {
            faces.remove(at: index)
            
            saveFaces { result in
                action(result, faces)
            }
        } else {
            action(false, faces)
        }
    }
    
    // save JSON file into app document directory
    func saveFaces(action: (Bool) -> Void) {
        // save JSON file into app document directory
        if let _ = FileManager.default.encodeJSON(self.jsonFileName, fileData: self.faces) {
            action(true)
        } else {
            action(false)
        }
    }
}
