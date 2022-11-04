//
//  FaceList.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/30/22.
//

import SwiftUI

struct FaceList: View {
    @Binding var faces: [Face]
    @Binding var showDeleteOption: Bool
    let geometry: GeometryProxy
    @Binding var needToRefreshFaceList: Bool
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
                        needToRefreshFaceList: $needToRefreshFaceList,
                        showDeleteOption: $showDeleteOption,
                        showDetailAction: showDetailAction,
                        showEditNameAction: showEditNameAction
                    )
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
        .animation(.linear, value: faces)
        //.transition(.scale)
    }
}
