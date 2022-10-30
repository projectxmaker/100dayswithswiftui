//
//  FaceList.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/30/22.
//

import SwiftUI

struct FaceList: View {
    @Binding var faces: [Face]
    
    let listVGridColumns: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: listVGridColumns) {
                ForEach(faces) { face in
                    if face.picture.isEmpty {
                        ProgressView()
                            .frame(maxWidth: 100, maxHeight: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .gray, radius: 10, x: 1, y: 1)
                    } else {
                        VStack {
                            if let data = try? Data(contentsOf: FileManager.default.getDocumentsDirectory().appendingPathComponent(face.thumbnail)), let loaded = UIImage(data: data) {
                                Image(uiImage: loaded)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(color: .gray, radius: 10, x: 1, y: 1)

                            }
                            Text(face.name)
                                .lineLimit(2)
                                .font(.caption)
                        }
                        
                    }
                }
            }
        }
    }
}
