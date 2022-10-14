//
//  ArrowView.swift
//  Drawing
//
//  Created by Pham Anh Tuan on 10/14/22.
//

import SwiftUI

struct ArrowView: View {
    struct Arrow: Shape {
        var insetAmount = 0.0
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            //path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLines([
                CGPoint(x: rect.midX, y: rect.minY),
                CGPoint(x: rect.minX, y: rect.midY / 2),
                CGPoint(x: rect.midX * 2/3, y: rect.midY / 2),
                CGPoint(x: rect.midX * 2/3, y: rect.maxY),
                CGPoint(x: rect.maxX * 4/6, y: rect.maxY),
                CGPoint(x: rect.maxX * 4/6, y: rect.midY / 2),
                CGPoint(x: rect.maxX, y: rect.midY / 2),
                CGPoint(x: rect.midX, y: rect.minY)
            ])
            
            return path
        }
    }
    
    var body: some View {
        Arrow()
            .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .padding()
    }
}

struct ArrowView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowView()
    }
}
