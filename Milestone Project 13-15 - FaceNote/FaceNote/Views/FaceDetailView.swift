//
//  FaceDetailView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceDetailView: View {
    let backgrounUIImageURL: URL
    let mainUIImageURL: URL
    let label: String
    let geometry: GeometryProxy
    
    @State var flipDegree: Double = 0

    @State private var backgroundUIImage = UIImage()
    
    @State private var mainUIImage = UIImage()

    static func getUIImage(url: URL) -> UIImage? {
        var data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            print("Cannot get image: \(error.localizedDescription)")
            return nil
        }
        
        return UIImage(data: data)
    }
    
    static func getUIImage(url: URL, size: CGSize) -> UIImage? {
        var image = getUIImage(url: url)
        if let newImage = image {
            image = newImage.preparingThumbnail(of: size)
        }
        
        return image
    }
    
    var body: some View {
        ZStack {
            if let newBackgroundUIImage = backgroundUIImage {
                Image(uiImage: newBackgroundUIImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: geometry.size.width)
                    .ignoresSafeArea()
                    .blur(radius: 10, opaque: true)
                    .saturation(0.2)
            }
                
            if let newMainUIImage = mainUIImage {
                VStack {
                    Image(uiImage: newMainUIImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .white, radius: 10, x: 1, y: 1)
                        .padding()
                    
                    Text(label)
                        .font(.title)
                        .foregroundColor(.white)
                        .shadow(color: .white, radius: 10, x: 1, y: 1)
                }
                .rotation3DEffect(.degrees(flipDegree), axis: (x: 0, y: 1, z: 0))
                .onAppear {
                    withAnimation {
                        flipDegree = flipDegree == 360 ? 0 : 360
                    }
                }
            }
        }
        .onAppear {
            backgroundUIImage = FaceDetailView.getUIImage(url: backgrounUIImageURL) ?? UIImage()
            
            let newSize = CGSize(width: geometry.size
                .width, height: geometry.size.width)

            mainUIImage = FaceDetailView.getUIImage(url: mainUIImageURL, size: newSize) ?? UIImage()
        }

    }
}
