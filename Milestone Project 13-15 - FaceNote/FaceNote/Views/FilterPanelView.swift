//
//  FilterPanelView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FilterPanelView: View {
    @Binding var filterKeyword: String
    @Binding var sortOrder: SortOrder
    @Binding var showFilterPanel: Bool

    var geometry: GeometryProxy
    var filterPanelHeightRatio = 0.05
    var animationDuration = 0.5
    var filterSystemImage = "arrow.up.arrow.down.square"
    @FocusState private var isKeywordFocused: Bool

    var body: some View {
        HStack {
            TextField(text: $filterKeyword) {
                Text("Keyword")
            }
            .textInputAutocapitalization(.never)
            .textFieldStyle(.roundedBorder)
            .focused($isKeywordFocused)

            Image(systemName: "arrow.up.arrow.down.square")
                .font(.title)
                .foregroundColor(.white)
                .onTapGesture {
                    sortOrder = (sortOrder == .forward) ? .reverse : .forward
                }
        }
        .padding(.horizontal, 5)
        .frame(maxWidth: geometry.size.width, maxHeight: showFilterPanel ? geometry.size.height * filterPanelHeightRatio : 0)
        .background(.blue)
        .opacity(showFilterPanel ? 1 : 0)
        .animation(.easeInOut(duration: 0.5), value: showFilterPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear {
            isKeywordFocused = true
        }
    }
}
