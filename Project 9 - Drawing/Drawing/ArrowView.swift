//
//  ArrowView.swift
//  Drawing
//
//  Created by Pham Anh Tuan on 10/14/22.
//

import SwiftUI

struct ArrowView: View {
    struct Arrow: Shape, InsettableShape {
        var insetAmount: CGFloat = 0
        
        var animatableData: CGFloat {
            get { return insetAmount }
            set { insetAmount = newValue }
        }

        func path(in newRect: CGRect) -> Path {
            var path = Path()
            
            path.addLines([
                CGPoint(x: newRect.midX, y: newRect.minY + insetAmount),
                CGPoint(x: newRect.minX + insetAmount, y: newRect.midY / 2 - insetAmount),
                CGPoint(x: newRect.maxX * 2/6 + insetAmount, y: newRect.midY / 2 - insetAmount),
                CGPoint(x: newRect.maxX * 2/6 + insetAmount, y: newRect.maxY - insetAmount),
                CGPoint(x: newRect.maxX * 4/6 - insetAmount, y: newRect.maxY - insetAmount),
                CGPoint(x: newRect.maxX * 4/6 - insetAmount, y: newRect.midY / 2 - insetAmount),
                CGPoint(x: newRect.maxX - insetAmount, y: newRect.midY / 2 - insetAmount),
                CGPoint(x: newRect.midX, y: newRect.minY + insetAmount)
            ])
            
            return path
        }

        func inset(by amount: CGFloat) -> some InsettableShape {
            var arrow = self
            arrow.insetAmount += amount
            return arrow
        }
    }
    
    @State private var insetAmount: CGFloat = 10
    
    var body: some View {
        Arrow()
            .strokeBorder(
                Color.blue,
                style: StrokeStyle(lineWidth: insetAmount, lineCap: .round, lineJoin: .round))
            .onTapGesture {
                insetAmount = CGFloat.random(in: 10...90)
            }
            
    }
}

struct ArrowView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowView()
    }
}
