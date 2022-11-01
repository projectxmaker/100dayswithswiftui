//
//  UIImage+GetUIImageByURL.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import UIKit

extension UIImage {
    static func getUIImage(url: URL) -> UIImage? {
        var data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            print("Cannot get image: \(error.localizedDescription)")
            return nil
        }
        
        return UIImage(data: data)
    }
    
    static func getUIImage(url: URL, size: CGSize) -> UIImage? {
        var image = getUIImage(url: url)
        if let newImage = image {
            image = newImage.preparingThumbnail(of: size)
        }
        
        return image
    }
    
    static func getUIImage(pathString: String) -> UIImage? {
        guard let imageURL = URL(string: pathString) else { return nil }
        
        return UIImage.getUIImage(url: imageURL)
    }
    
    static func getUIImage(pathString: String, size: CGSize) -> UIImage? {
        var image = getUIImage(pathString: pathString)
        if let newImage = image {
            image = newImage.preparingThumbnail(of: size)
        }
        
        return image
    }
}
