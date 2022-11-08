//
//  FaceDetailView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI
import MapKit

struct FaceDetailView: View {
    @EnvironmentObject var faceList: FaceList
    @State private var showFaceDetailView = false
    @State private var showMap = false
    
    var geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            VStack {
                Image(uiImage: faceList.mainUIImage(geometry: geometry, face: faceList.tappedFace))
                    .resizable()
                    .scaledToFill()
                    .frame(height: geometry.size.width * 0.8)
                    .clipShape(Circle())
                    .shadow(color: .white, radius: 20, x: 1, y: 1)
                
                Text(faceList.tappedFace?.name ?? "Unknown")
                    .font(.title)
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 10, x: 1, y: 1)
                
                Spacer()
            }
            .scaleEffect(showFaceDetailView ? 1 : 0)
            .onChange(of: showFaceDetailView) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        showMap.toggle()
                    }
                    
                }
            }
            
            if showMap {
                VStack {
                    Spacer()
                    FaceLocationMapView(actionToFullscreen: {
                        faceList.openFaceLocationMap()
                    })
                    .ignoresSafeArea()
                    .frame(maxHeight: showMap ? 300 : 0)
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .background(
            Color.black
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 10, opaque: true)
                .saturation(0.2)
                .opacity(showFaceDetailView ? 0.7 : 0)
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showFaceDetailView.toggle()
            }
        }
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.2)) {
                showFaceDetailView.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                faceList.closeFaceDetailAction()
            }
        }
    }
}
