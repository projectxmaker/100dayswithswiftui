//
//  FileManager+JSONEncodeDecode.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import UIKit

extension FileManager {
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func decodeJSON<T: Codable>(_ file: String) -> T? {
        let url = self.getDocumentsDirectory().appendingPathComponent(file)

        guard let data = try? Data(contentsOf: url) else {
            print("Failed to load \(file) from App document directory.")
            return nil
        }
        
        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            print("Failed to decode \(file) from App document directory.")
            return nil
        }

        return loaded
    }
    
    func encodeJSON<T: Codable>(_ fileName: String, fileData: T, applyEncryption: Bool = false) -> URL? {
        let url = self.getDocumentsDirectory().appendingPathComponent(fileName)
        
        var options: Data.WritingOptions = [.atomic]
        if applyEncryption {
            options = [.atomic, .completeFileProtection]
        }
        
        do {
            let data = try JSONEncoder().encode(fileData)
            try data.write(to: url, options: options)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return url
    }
    
    func saveUIImage(_ uiImage: UIImage, name: String, compressionQuality: Double = 0.8) -> URL? {
        guard let data = uiImage.jpegData(compressionQuality: compressionQuality) else { return nil }
        
        let imageURL = self.getDocumentsDirectory().appendingPathComponent(name)

        do {
            try data.write(to: imageURL)
        } catch {
            return nil
        }
        
        return imageURL
    }
}

