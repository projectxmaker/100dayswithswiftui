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
    var isFilterPanelShowed: Bool
    var geometry: GeometryProxy
    var filterPanelHeightRatio = 0.05
    var filterPanelAnimationDuration = 0.5
    var filterSystemImage = "arrow.up.arrow.down.square"
    var transition: AnyTransition = .asymmetric(insertion: .move(edge: .top).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity))
    
    @State private var switcher = false
    @FocusState private var isKeywordFocused: Bool
    
    var body: some View {
        ZStack {
            Text("Trigger")
                .hidden()
                .onChange(of: isFilterPanelShowed) { newValue in
                    withAnimation(.easeInOut(duration: filterPanelAnimationDuration)) {
                        switcher.toggle()
                        isKeywordFocused = true
                    }
                }

            if switcher {
                HStack {
                    TextField(text: $filterKeyword) {
                        Text("Keyword")
                    }
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .focused($isKeywordFocused)
                    
                    Button {
                        sortOrder = (sortOrder == .forward) ? .reverse : .forward
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.square")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 5)
                .frame(maxWidth: geometry.size.width, maxHeight: switcher ? geometry.size.height * filterPanelHeightRatio : 0)
                .background(.blue)
                .transition(transition)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}
