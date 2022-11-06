//
//  FaceDetailView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceDetailView: View {
    @EnvironmentObject var faceList: FaceList
    @State private var showFaceDetailView = false
    
    var geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(0.1)
                .padding([.horizontal], -20)
                .overlay {
                    Image(uiImage: faceList.backgroundUIImage(face: faceList.tappedFace))
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: geometry.size.width)
                        .ignoresSafeArea()
                        .blur(radius: 10, opaque: true)
                        .saturation(0.2)
                        .opacity(showFaceDetailView ? 0.7 : 0)
                    
                    VStack {
                        Image(uiImage: faceList.mainUIImage(geometry: geometry, face: faceList.tappedFace))
                            .resizable()
                            .scaledToFill()
                            .frame(height: geometry.size.width * 0.9)
                            .clipShape(Circle())
                            .shadow(color: .white, radius: 10, x: 1, y: 1)
                            .padding()
    
                        Text(faceList.tappedFace?.name ?? "Unknown")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(color: .white, radius: 10, x: 1, y: 1)
                    }
                    .scaleEffect(showFaceDetailView ? 1 : 0)
                }
        }
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
