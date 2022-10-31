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
        @Published var newFaceImage: UIImage?
        @Published var newFaceName: String = ""
        @Published var keyword: String = ""
        @Published var sortOrder = SortOrder.forward
        
        private var dataController = DataController.shared
        
        var wrappedNewFaceImage: UIImage {
            newFaceImage ?? UIImage()
        }
        
        init() {
            filteredFaces()
        }
        
        func filteredFaces() {
            faces = dataController.filteredFaces(keyword: keyword, sortOrder: sortOrder)
        }
        
        func createNewFace(actionBefore: (Bool) -> Void, actionAfter: @escaping (Bool, Face?) -> Void) {
            guard let faceImage = newFaceImage else {
                actionBefore(false)
                return
            }
            
            // create a place holder for new Face on List
            dataController.createNewFace(uiImage: faceImage, name: newFaceName) { newFace in
                // create a place holder for new Face on List
                self.faces.insert(newFace, at: 0)
                actionBefore(true)
            } actionAfter: { succeeded, newFace in
                // update new Face to relating place holder on List
                if let newFace = newFace {
                    if let tobeUpdatedFaceIndex = self.faces.firstIndex(of: newFace) {
                        self.faces[tobeUpdatedFaceIndex] = newFace
                    }
                }
                
                actionAfter(succeeded, newFace)
            }
        }
    }
}
