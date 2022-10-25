//
//  ScrollableInfo.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import SwiftUI

struct ScrollableInfo<T: View>: View {
    var label: String
    var geometry: GeometryProxy
    var axis = Axis.Set.vertical
    var heightRatio = 0.25
    var content: () -> T
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.headline)
            ScrollView(axis, showsIndicators: false, content: content)
            .frame(width: geometry.size.width, height: geometry.size.height * heightRatio, alignment: .leading)
            .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            .background(RoundedRectangle(cornerRadius: 10).fill(.thinMaterial))
        }
    }
}
