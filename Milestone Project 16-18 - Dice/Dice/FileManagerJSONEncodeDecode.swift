//
//  FileManagerJSONEncodeDecode.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/18/22.
//

import Foundation

extension FileManager {
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func getFileURL(fileName: String) -> URL {
        if #available(iOS 16, *) {
            return self.getDocumentsDirectory().appending(component: fileName)
        } else {
            return self.getDocumentsDirectory().appendingPathComponent(fileName)
        }
    }
    
    func decodeJSON<T: Codable>(_ fileName: String) -> T? {
        let url = self.getFileURL(fileName: fileName)

        guard let data = try? Data(contentsOf: url) else {
            print("Failed to load \(fileName) from App document directory.")
            return nil
        }
        
        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            print("Failed to decode \(fileName) from App document directory.")
            return nil
        }

        return loaded
    }
    
    func encodeJSON<T: Codable>(_ fileName: String, fileData: T, applyEncryption: Bool = false) -> URL? {
        let url = self.getFileURL(fileName: fileName)
        
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
}
