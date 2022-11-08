//
//  CreateFaceView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/6/22.
//

import SwiftUI

struct CreateFaceView: View {
    @EnvironmentObject var setFaceInfoVM: SetFaceInfoViewModel
    @EnvironmentObject var locationFetcher: LocationFetcher
   
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
            
            if let location = self.locationFetcher.lastKnownLocation {
                print("location: \(location)")
                setFaceInfoVM.faceLatitude = location.latitude
                setFaceInfoVM.faceLongitude = location.longitude
            } else {
                print("Your location is unknown")
            }
        }
    }
}
