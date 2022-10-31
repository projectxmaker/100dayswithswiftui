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

    var body: some View {
        VStack {
            Form {
                Section("Filter") {
                    TextField(text: $filterKeyword) {
                        Text("Keyword")
                    }
                    .textInputAutocapitalization(.never)
                }
                
                Section("Order by") {
                    Picker("Order by: ", selection: $sortOrder) {
                        Text("Accending").tag(SortOrder.forward)
                        Text("Decreasing").tag(SortOrder.reverse)
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
        .frame(maxWidth: geometry.size.width, maxHeight: showFilterPanel ? geometry.size.height * 0.23 : 0)
        .opacity(showFilterPanel ? 1 : 0)
        .transition(.slide)
        .animation(.easeInOut(duration: 0.5), value: showFilterPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
