//
//  ContentView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject var locationFetcher = LocationFetcher()
    @State var isCoreLocationEnabled: Bool? = nil

    var body: some View {
        ZStack {
            Image("universal")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .blendMode(.luminosity)
            
            VStack {
                if let isCoreLocationEnabled = isCoreLocationEnabled {
                    if isCoreLocationEnabled {
                        GeometryReader { geometry in
                            ListView(geometry: geometry)
                        }
                        .environmentObject(locationFetcher)
                    } else {
                        VStack(alignment: .center) {
                            Text("Please enable Core Location.\n It is required to create new Face.")
                                .font(.title)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .task {
                locationFetcher.start()
            }
            .onChange(of: locationFetcher.authorizationStatus) { _ in
                isCoreLocationEnabled = locationFetcher.isAuthorized
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
