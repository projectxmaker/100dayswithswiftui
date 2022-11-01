//
//  FaceView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceView: View {
    @State private var showFace = false
    @State private var flipDegree: Double = 0
    @State private var showActions = false
    
    var face: Face
    var tapOnAFaceAction: (Face) -> Void
    var showEditNameAction: (Face) -> Void
    var showDeleteAction: (Face) -> Void
    
    var body: some View {
        VStack {
            if let loadedUIImage = UIImage.getUIImage(url: FileManager.default.getFileURL(fileName: face.thumbnail)) {
                Image(uiImage: loadedUIImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(color: .gray, radius: 10, x: 1, y: 1)
                    .rotation3DEffect(.degrees(flipDegree), axis: (x: 0, y: 1, z: 0))
            }
            Text(face.name)
                .lineLimit(2)
                .font(.caption)
        }
        .scaleEffect(showFace ? 1 : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.7)) {
                showFace.toggle()
            }
        }
        .onDisappear {
            showFace = false
        }
        .onTapGesture {
            withAnimation {
                flipDegree = flipDegree == 360 ? 0 : 360
            }

            tapOnAFaceAction(face)
        }
        .onLongPressGesture(perform: {
            showActions.toggle()
        })
        .confirmationDialog("\(face.name)".uppercased(), isPresented: $showActions) {
            Button("Change Name") {
                showEditNameAction(face)
            }
            
            Button("Delete", role: .destructive) {
                showDeleteAction(face)
            }
            
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text(String("\(face.name)").uppercased())
        }
    }
}
