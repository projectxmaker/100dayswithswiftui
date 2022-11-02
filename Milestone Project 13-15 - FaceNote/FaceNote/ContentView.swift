//
//  ContentView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/29/22.
//

import SwiftUI

struct ContentView: View {
    @State private var longPressOnScreen = false
    @State private var tapOnScreen = false

    private func longPressOnFace() -> some Gesture {
        let minimumLongPressDuration: Double = 1
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .onEnded { value in
                print("long press on screen")
                longPressOnScreen.toggle()
            }
        return longPressDrag
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ListView(tapOnScreen: $tapOnScreen, longPressOnScreen: $longPressOnScreen, geometry: geometry)
            }
            .onTapGesture(count: 2, perform: {
            })
            .gesture(longPressOnFace())
            .gesture(TapGesture(count: 1)
                .onEnded({ void in
                    print("tap on screen")
                    tapOnScreen.toggle()
                })
            )
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
