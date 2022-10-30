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
    
    func createNewFace(uiImage: UIImage, name: String, action: (Bool, Face?) -> Void) {
        let faceId = UUID()
        
        if let faceImageURL = FileManager.default.saveUIImage(uiImage, name: faceId.uuidString) {
            
            var picturePath = ""
            if #available(iOS 16, *) {
                picturePath = faceImageURL.path()
            } else {
                picturePath = faceImageURL.path
            }
            
            let newFace = Face(id: faceId, name: name, picture: picturePath)
            
            faces.append(newFace)
            
            if let _ = FileManager.default.encodeJSON(jsonFileName, fileData: self.faces) {
                action(true, newFace)
            }
            
            action(false, nil)
        } else {
            action(false, nil)
        }
    }
}
