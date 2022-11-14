//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Pham Anh Tuan on 11/13/22.
//

import SwiftUI

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    let fadeOutFromTopThreshold: CGFloat = 200
    let scaleUpToBottomThreshold: CGFloat = 2
    let scaleUpToTopThreshold: CGFloat = 0.5
    
    func getOpacityOfView(yAxis: CGFloat) -> Double {
        return yAxis < fadeOutFromTopThreshold ? yAxis / fadeOutFromTopThreshold : 1
    }
    
    func getScaleOfView(midYAxis: CGFloat, globalMidY: CGFloat) -> CGFloat {
        let newScaleRate = midYAxis / globalMidY

        var newScale = 1 * newScaleRate
        
        if newScale > scaleUpToBottomThreshold {
            newScale = scaleUpToBottomThreshold
        } else if newScale < scaleUpToTopThreshold {
            newScale = scaleUpToTopThreshold
        }
        
        return newScale
    }
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(colors[index % 7])
                            .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size .height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            .opacity(getOpacityOfView(yAxis: geo.frame(in: .global).minY))
                            .scaleEffect(getScaleOfView(midYAxis: geo.frame(in: .global).midY, globalMidY: fullView.frame(in: .global).midY))
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
