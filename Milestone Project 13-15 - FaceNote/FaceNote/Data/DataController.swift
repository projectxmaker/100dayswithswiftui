//
//  DataController.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import Foundation

class DataController {
    static var shared = DataController()
    
    let jsonFileName = "faces"
    
    func getFaceList() -> [Face] {
        guard let faces = FileManager.default.decodeJSON(jsonFileName) as [Face]? else {
            return [Face]()
        }
        
        return faces
    }
}
