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
    var tapOnAFaceDetailAction: () -> Void
    
    @State private var backgroundUIImage = UIImage()
    @State private var mainUIImage = UIImage()
    
    @State private var showFaceDetailView = false

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
            Color.gray
                .ignoresSafeArea()
                .opacity(0.1)
                .padding([.horizontal], -20)
                .overlay {
                    Image(uiImage: backgroundUIImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: geometry.size.width)
                        .ignoresSafeArea()
                        .blur(radius: 10, opaque: true)
                        .saturation(0.2)
                        .opacity(showFaceDetailView ? 0.7 : 0)
                    
                    VStack {
                        Image(uiImage: mainUIImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: geometry.size.width * 0.9)
                            .clipShape(Circle())
                            .shadow(color: .white, radius: 10, x: 1, y: 1)
                            .padding()
    
                        Text(label)
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(color: .white, radius: 10, x: 1, y: 1)
                    }
                    .scaleEffect(showFaceDetailView ? 1 : 0)
                }
        }
        .onAppear {
            backgroundUIImage = FaceDetailView.getUIImage(url: backgrounUIImageURL) ?? UIImage()
            
            let newSize = CGSize(width: geometry.size.width * 0.9
            , height: geometry.size.width * 0.9)

            mainUIImage = FaceDetailView.getUIImage(url: mainUIImageURL, size: newSize) ?? UIImage()
            
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
