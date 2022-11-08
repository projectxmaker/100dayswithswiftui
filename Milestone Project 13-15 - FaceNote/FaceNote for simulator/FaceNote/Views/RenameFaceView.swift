//
//  ChangeFaceNameView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/6/22.
//

import SwiftUI

struct RenameFaceView: View {
    @EnvironmentObject var setFaceInfoVM: SetFaceInfoViewModel
   
    var geometry: GeometryProxy
    var face: Face
    
    var body: some View {
        FaceFormView(
            geometry: geometry
        )
        .onAppear {
            setFaceInfoVM.actionType = .rename
            setFaceInfoVM.editedFace = face
            setFaceInfoVM.faceName = setFaceInfoVM.editedFace?.name ?? "Unknown"
            setFaceInfoVM.backgroundUIImage(face: setFaceInfoVM.editedFace)
            setFaceInfoVM.mainUIImage(geometry: geometry, face: setFaceInfoVM.editedFace)
        }
    }
}
