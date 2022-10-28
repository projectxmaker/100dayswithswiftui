//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Pham Anh Tuan on 10/28/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
