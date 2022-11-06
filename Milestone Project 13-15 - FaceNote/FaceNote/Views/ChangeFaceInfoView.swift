//
//  ChangeFaceInfoView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/7/22.
//

import SwiftUI

struct ChangeFaceInfoView: View {
    @EnvironmentObject var setFaceInfoVM: SetFaceInfoViewModel
   
    var geometry: GeometryProxy
    var face: Face
    
    var body: some View {
        FaceFormView(
            geometry: geometry
        )
        .onAppear {
            setFaceInfoVM.actionType = .changeFace
            setFaceInfoVM.editedFace = face
            setFaceInfoVM.faceName = setFaceInfoVM.editedFace?.name ?? "Unknown"
            setFaceInfoVM.backgroundUIImage(uiImage: setFaceInfoVM.changeNewFaceImage)
            setFaceInfoVM.mainUIImage(geometry: geometry, uiImage: setFaceInfoVM.changeNewFaceImage)
        }
    }
}
