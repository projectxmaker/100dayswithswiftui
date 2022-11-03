//
//  FaceList.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/30/22.
//

import SwiftUI

struct FaceList: View {
    @Binding var faces: [Face]
    var showDeleteOptionOnEachFace: Bool
    let geometry: GeometryProxy
    var showDeleteOptionOnEachFaceAction: (Bool) -> Void
    var showDetailAction: (Face) -> Void
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
                        showDeleteOptionOnEachFace: showDeleteOptionOnEachFace,
                        showDeleteOptionOnEachFaceAction: showDeleteOptionOnEachFaceAction,
                        showDetailAction: showDetailAction,
                        showEditNameAction: showEditNameAction,
                        showDeleteAction: showDeleteAction
                    )
                }
            }
            .padding(.top, 10)
        }
    }
}
