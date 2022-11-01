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
    var showEditNameAction: (Face) -> Void
    var showDeleteAction: (Face) -> Void

    let listVGridColumns: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: listVGridColumns) {
                ForEach(faces) { face in
                    FaceView(
                        face: face,
                        tapOnAFaceAction: tapOnAFaceAction,
                        showEditNameAction: showEditNameAction,
                        showDeleteAction: showDeleteAction
                    )
                }
            }
        }
    }
}
