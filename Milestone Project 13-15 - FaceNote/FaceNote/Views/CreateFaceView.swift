//
//  CreateFaceView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/6/22.
//

import SwiftUI

struct CreateFaceView: View {
    @EnvironmentObject var setFaceInfoVM: SetFaceInfoViewModel
   
    var geometry: GeometryProxy
    
    var body: some View {
        FaceFormView(
            geometry: geometry
        )
        .onAppear {
            setFaceInfoVM.actionType = .create
            setFaceInfoVM.faceName = ""
            setFaceInfoVM.mainUIImage(geometry: geometry, uiImage: setFaceInfoVM.newFaceImage)
            setFaceInfoVM.backgroundUIImage(uiImage: setFaceInfoVM.newFaceImage)
        }
    }
}
