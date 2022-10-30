//
//  UpdateFaceNameView-ViewModel.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/30/22.
//

import UIKit

extension UpdateFaceNameView {
    @MainActor class ViewModel: ObservableObject {
        @Published var faceName: String = ""
        
        var newFaceImage: UIImage
        var actionCancel: () -> Void
        var actionCreate: () -> Void
        
        init(newFaceImage: UIImage, actionCancel: @escaping () -> Void, actionCreate: @escaping () -> Void) {
            self.newFaceImage = newFaceImage
            self.actionCancel = actionCancel
            self.actionCreate = actionCreate
        }
        
        func isFaceNameValid() -> Bool {
            !faceName.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
}
