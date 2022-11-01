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
}
