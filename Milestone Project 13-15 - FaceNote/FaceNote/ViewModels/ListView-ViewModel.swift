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
        @Published var keyword: String = ""
        @Published var sortOrder = SortOrder.forward
        @Published var modifiedFace: Face?
        
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
        
        func refreshFaceList() {
            modifiedFace = dataController.modifiedFace
            filteredFaces()
        }
    }
}
