//
//  ListView-ViewModel.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import UIKit

extension ListView {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var faces = [Face]()
        @Published var newFaceImage: UIImage?
        @Published var newFaceName: String = ""
        
        private var dataController = DataController.shared
        
        init() {
            faces = dataController.getFaceList()
        }
        
        func createNewFace(action: (Bool, Face?) -> Void) {
            guard let faceImage = newFaceImage else {
                action(false, nil)
                return
            }
            
            dataController.createNewFace(uiImage: faceImage, name: newFaceName) { succeeded, newFace in
                
                if let newFace = newFace {
                    faces.insert(newFace, at: 0)
                }
                
                action(succeeded, newFace)
            }
        }
    }
}
