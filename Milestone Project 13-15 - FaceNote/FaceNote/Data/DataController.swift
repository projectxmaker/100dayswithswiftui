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
    
    func getFaceList() -> [Face] {
        guard let faces = FileManager.default.decodeJSON(jsonFileName) as [Face]? else {
            return [Face]()
        }
        
        self.faces = faces
        
        return faces
    }
    
    func createNewFace(uiImage: UIImage, name: String, actionBefore: (Face) -> Void, actionAfter: @escaping (Bool, Face?) -> Void) {
        let faceId = UUID()
        
        var newFace = Face(id: faceId, name: name, picture: "")
        actionBefore(newFace)
        
        if let faceImageURL = FileManager.default.saveUIImage(uiImage, name: faceId.uuidString, compressionQuality: 0.5) {
            
            var picturePath = ""
            if #available(iOS 16, *) {
                picturePath = faceImageURL.path()
            } else {
                picturePath = faceImageURL.path
            }
            
            newFace.picture = picturePath
            
            self.faces.insert(newFace, at: 0)
            
            if let _ = FileManager.default.encodeJSON(self.jsonFileName, fileData: self.faces) {
                actionAfter(true, newFace)
            } else {
                actionAfter(false, nil)
            }
        } else {
            actionAfter(false, nil)
        }
    }
}
