//
//  FaceDetailView+ViewModel.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/1/22.
//

import UIKit
import SwiftUI

extension FaceDetailView {
    @MainActor class ViewModel: ObservableObject {
        @Published var face: Face?
        
        var backgroundUIImage: UIImage {
            if let face = self.face {
                let backgroundImageURL = FileManager.default.getFileURL(fileName: face.thumbnail)
                return UIImage.getUIImage(url: backgroundImageURL) ?? UIImage()
            } else {
                return UIImage()
            }
        }
        
        var mainUIImage: UIImage {
            guard
                let face = self.face,
                let geometry = self.geometry
            else {
                return UIImage()
            }
            
            let newSize = CGSize(width: geometry.size.width * 0.9
            , height: geometry.size.width * 0.9)

            let mainImageURL = FileManager.default.getFileURL(fileName: face.picture)
            return UIImage.getUIImage(url: mainImageURL, size: newSize) ?? UIImage()
        }
        
        var geometry: GeometryProxy?
    }
}
