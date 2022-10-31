//
//  FaceView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceView: View {
    let uiImageURL: URL
    let label: String
    
    @State private var showFace = false
    
    private func getUIImage() -> UIImage? {
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
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray, radius: 10, x: 1, y: 1)
            }
            Text(label)
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
    }
}
