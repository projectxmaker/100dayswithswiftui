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
    
    func getSquareShape() -> UIImage {
        // The shortest side
        let sideLength = min(
            self.size.width,
            self.size.height
        )

        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = self.size
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0

        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral

        // Center crop the image
        let sourceCGImage = self.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!
        
        // Use the cropped cgImage to initialize a cropped
        // UIImage with the same image scale and orientation
        return UIImage(
            cgImage: croppedCGImage,
            scale: self.imageRendererFormat.scale,
            orientation: self.imageOrientation
        )
    }
}
