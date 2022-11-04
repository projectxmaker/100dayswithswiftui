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
    @Binding var refreshTheList: Bool
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
                        showDeleteOption: $showDeleteOption,
                        showDetailAction: showDetailAction,
                        showEditNameAction: showEditNameAction
                    )
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)
        }
    }
}
