//
//  FileManager+Decodable.swift
//  BucketList
//
//  Created by Pham Anh Tuan on 10/27/22.
//

import Foundation

extension FileManager {
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func decodeJSON<T: Codable>(_ file: String) -> T {
        let url = self.getDocumentsDirectory().appendingPathComponent(file)

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
    
    func encodeJSON<T: Codable>(_ fileName: String, fileData: T) -> URL? {
        let url = self.getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(fileData)
            try data.write(to: url)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return url
    }
}
