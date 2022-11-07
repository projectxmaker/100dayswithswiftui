//
//  FaceLocationMapView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 11/7/22.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct FaceLocationMapView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

    var isSmallSizeShowed = true
    var actionToFullscreen: (() -> Void)?
    var actionToExitFullscreen: (() -> Void)?
    var actionToExit: (() -> Void)?

    let locations = [
        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]

    var body: some View {
        Map(coordinateRegion: $mapRegion)
            .overlay(alignment: .centerLastTextBaseline) {
                if isSmallSizeShowed {
                    Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle")
                        .frame(height: 40)
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .offset(x: 0, y: -20)
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
//        Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
//            MapMarker(coordinate: location.coordinate)
//        }
    }
}

//
//struct FaceLocationMapView: View {
//    @EnvironmentObject var faceList: FaceList
//
////    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//
//
//    @State var faces: [Face]
//    @State var mapRegion: MKCoordinateRegion
//    //@State var mapHeight: CGFloat = 300
//
////    init(face: Face) {
////        var currentFace = face
////        currentFace.latitude = 51.5
////        currentFace.longitude = -0.12
////
////        self._faces = State(wrappedValue: [currentFace])
////
////        self._mapRegion = State(wrappedValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentFace.latitude, longitude: currentFace.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
////    }
//
//    var body: some View {
//        Map(coordinateRegion: $mapRegion)
////        Map(coordinateRegion: $mapRegion, annotationItems: faces) { face in
////            MapMarker(coordinate: CLLocationCoordinate2D(latitude: face.latitude, longitude: face.longitude))
////        }
//
////        Map(coordinateRegion: $mapRegion, annotationItems: faces) { face in
////            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: face.latitude, longitude: face.longitude)) {
////                Image(uiImage: faceList.backgroundUIImage(face: face))
////                    .resizable()
////                    .scaledToFill()
////                    .frame(height: 100)
////                    .clipShape(Circle())
////                    .shadow(color: .white, radius: 10, x: 1, y: 1)
////            }
////        }
//        //.edgesIgnoringSafeArea(.bottom)
//        //.frame(minHeight: mapHeight)
////        .ignoresSafeArea()
//    }
//}
