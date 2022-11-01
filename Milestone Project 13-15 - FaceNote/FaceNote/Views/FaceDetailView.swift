//
//  FaceDetailView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceDetailView: View {
    @StateObject private var viewModel = FaceDetailView.ViewModel()
    @State private var showFaceDetailView = false
    
    var face: Face
    var geometry: GeometryProxy
    var tapOnAFaceDetailAction: () -> Void
    
    init(face: Face, geometry: GeometryProxy, tapOnAFaceDetailAction: @escaping () -> Void) {
        self.face = face
        self.geometry = geometry
        self.tapOnAFaceDetailAction = tapOnAFaceDetailAction
    }
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(0.1)
                .padding([.horizontal], -20)
                .overlay {
                    Image(uiImage: viewModel.backgroundUIImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: geometry.size.width)
                        .ignoresSafeArea()
                        .blur(radius: 10, opaque: true)
                        .saturation(0.2)
                        .opacity(showFaceDetailView ? 0.7 : 0)
                    
                    VStack {
                        Image(uiImage: viewModel.mainUIImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: geometry.size.width * 0.9)
                            .clipShape(Circle())
                            .shadow(color: .white, radius: 10, x: 1, y: 1)
                            .padding()
    
                        Text(face.name)
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(color: .white, radius: 10, x: 1, y: 1)
                    }
                    .scaleEffect(showFaceDetailView ? 1 : 0)
                }
        }
        .onAppear {
            viewModel.face = self.face
            viewModel.geometry = self.geometry
            
            withAnimation(.easeOut(duration: 0.5)) {
                showFaceDetailView.toggle()
            }
        }
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.2)) {
                showFaceDetailView.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tapOnAFaceDetailAction()
            }
        }

    }
}
