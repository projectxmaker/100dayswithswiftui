//
//  FaceList.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/30/22.
//

import SwiftUI

struct FaceList: View {
    @Binding var faces: [Face]
    @Binding var showDeleteOptionOnEachFace: Bool
    let geometry: GeometryProxy
    @Binding var refreshTheList: Bool
//    var showDeleteOptionOnEachFaceAction: (Bool) -> Void
    var showDetailAction: (Face) -> Void
    var showEditNameAction: (Face) -> Void

    let listVGridColumns: [GridItem] = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: listVGridColumns) {
                ForEach(faces) { face in
                    FaceView(
                        face: face,
                        refreshTheList: $refreshTheList,
                        showDeleteOptionOnEachFace: $showDeleteOptionOnEachFace,
                        showDetailAction: showDetailAction,
                        showEditNameAction: showEditNameAction
                    )
                }
            }
            .padding(.top, 10)
        }
    }
}
