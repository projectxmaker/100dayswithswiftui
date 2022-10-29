//
//  ListView-ViewModel.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import Foundation

extension ListView {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var faces = [Face]()
        @Published var newFacePicturePath = ""
        @Published var newFaceName = ""
        
        private var dataController = DataController.shared
        
        init() {
            faces = dataController.getFaceList()
        }
    }
}
