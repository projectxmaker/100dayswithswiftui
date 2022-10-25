//
//  ScrollableInfo.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import SwiftUI

struct ScrollableInfo: View {
    var label: String
    var content: String
    var geometry: GeometryProxy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.headline)
            ScrollView(.vertical, showsIndicators: false) {
                Text(content)
            }
            .frame(width: geometry.size.width, height: geometry.size.height/4, alignment: .leading)
            .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            .background(RoundedRectangle(cornerRadius: 10).fill(.thinMaterial))
        }
    }
}
