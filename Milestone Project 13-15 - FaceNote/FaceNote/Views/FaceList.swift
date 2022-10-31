//
//  FaceList.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/30/22.
//

import SwiftUI

struct FaceList: View {
    @Binding var faces: [Face]
    let geometry: GeometryProxy
    var tapOnAFaceAction: (Face) -> Void

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
                        FaceView(uiImageURL: FileManager.default.getDocumentsDirectory().appendingPathComponent(face.thumbnail), label: face.name)
                            .onTapGesture {
                                tapOnAFaceAction(face)
                            }
                    }
                }
            }
        }
    }
}
