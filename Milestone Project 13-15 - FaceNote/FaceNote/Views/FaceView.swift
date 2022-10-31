//
//  FaceView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceView: View {
    let face: Face
    
    @State private var showFace = false
    @State private var flipDegree: Double = 0
    
    var tapOnAFaceAction: (Face) -> Void
    
    private func getUIImage() -> UIImage? {
        let uiImageURL = FileManager.default.getDocumentsDirectory().appendingPathComponent(face.thumbnail)
        
        var data: Data
        do {
            data = try Data(contentsOf: uiImageURL)
        } catch {
            print("Cannot get image: \(error.localizedDescription)")
            return nil
        }
        
        return UIImage(data: data)
    }
    
    var body: some View {
        VStack {
            if let loadedUIImage = getUIImage() {
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
    }
}
