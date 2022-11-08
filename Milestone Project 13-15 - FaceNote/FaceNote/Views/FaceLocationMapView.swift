//
//  FaceLocationMapView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/7/22.
//

import SwiftUI
import MapKit

struct FaceLocationMapView: View {
    @EnvironmentObject var faceList: FaceList
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var isSmallSizeShowed = true
    var actionToFullscreen: (() -> Void)?
    var actionToExitFullscreen: (() -> Void)?
    var actionToExit: (() -> Void)?
    
    @State var faces = [Face]()
    
    private func getMap() -> some View {
        if isSmallSizeShowed {
            return Map(coordinateRegion: $mapRegion, annotationItems: faces) { face in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: face.latitude, longitude: face.longitude))
            }
        } else {
            return Map(coordinateRegion: $mapRegion, annotationItems: faces) { face in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: face.latitude, longitude: face.longitude)) {
                    Image(uiImage: faceList.backgroundUIImage(face: face))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .shadow(color: .white, radius: 10, x: 1, y: 1)
                }
            }
        }
    }
    
    var body: some View {
        getMap()
            .overlay(alignment: .centerLastTextBaseline) {
            if isSmallSizeShowed {
                Image(systemName: "arrow.down.forward.and.arrow.up.backward.circle")
                    .frame(height: 40)
                    .font(.largeTitle)
                    .offset(x: 0, y: -20)
                    .foregroundColor(.blue)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .onTapGesture {
                        if let action = actionToFullscreen {
                            action()
                        }
                    }
            } else {
                HStack {
                    Spacer()

                    Image(systemName: "arrow.down.forward.and.arrow.up.backward.circle")
                        .onTapGesture {
                            if let action = actionToExitFullscreen {
                                action()
                            }
                        }
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

                    Spacer(minLength: 100)

                    Image(systemName: "xmark.circle")
                        .onTapGesture {
                            if let action = actionToExit {
                                action()
                            }
                        }

                    Spacer()
                }
                .frame(height: 40)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .offset(x: 0, y: -20)
            }
        }
        .task {
            if let currentFace = faceList.tappedFace {
                print("current face: \(currentFace)")
                faces.append(currentFace)

                mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentFace.latitude, longitude: currentFace.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            }
        }
    }
}
