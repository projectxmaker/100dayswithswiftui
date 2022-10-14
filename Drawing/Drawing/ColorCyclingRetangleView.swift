//
//  ColorCyclingRetangleView.swift
//  Drawing
//
//  Created by Pham Anh Tuan on 10/14/22.
//

import SwiftUI

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var startX: CGFloat = 0.0
    var startY: CGFloat = 0.0
    var endX: CGFloat = 0.0
    var endY: CGFloat = 0.0
    
    let steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps, id: \.self) { value in
                Rectangle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                            startPoint: UnitPoint(x: startX, y: startY),
                            endPoint: UnitPoint(x: endX, y: endY)
                        ),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

func createSeparator() -> some View {
    Rectangle()
        .frame(maxWidth: .infinity / 2, maxHeight: 2)
        .background(.gray)
        .opacity(0.1)
}

struct ColorCyclingRetangleView: View {
    @State private var colorCycle = 0.0
    @State private var gradientStartX = 0.0
    @State private var gradientStartY = 0.0
    @State private var gradientEndX = 0.0
    @State private var gradientEndY = 0.0
    
    var body: some View {
        VStack {
            ColorCyclingRectangle(
                amount: colorCycle,
                startX: gradientStartX,
                startY: gradientStartY,
                endX: gradientEndX,
                endY: gradientEndY
            )
            .frame(width: 300, height: 300)

            HStack {
                Text("Color: ")
                    .fontWeight(.bold)
                Slider(value: $colorCycle)
            }
            
            createSeparator()
            
            HStack {
                Text("Gradient's Start Position")
                    .fontWeight(.bold)
                Spacer()
            }
            
            HStack {
                Text("X: ")
                Slider(value: $gradientStartX, in: 0.0...1.0)
            }
            
            HStack {
                Text("Y: ")
                Slider(value: $gradientStartY, in: 0.0...1.0)
            }
            
            createSeparator()
            
            HStack {
                Text("Gradient's End Position")
                    .fontWeight(.bold)
                Spacer()
            }
            
            HStack {
                Text("X: ")
                Slider(value: $gradientEndX, in: 0.0...1.0)
            }
            
            HStack {
                Text("Y: ")
                Slider(value: $gradientEndY, in: 0.0...1.0)
            }
        }
        
    }
}

struct ColorCyclingRetangleView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCyclingRetangleView()
    }
}
