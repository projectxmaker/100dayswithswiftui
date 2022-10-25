//
//  FilterPanel.swift
//  Contacts
//
//  Created by Pham Anh Tuan on 10/25/22.
//

import CoreData
import SwiftUI

struct FilterPanelView: View {
    @Binding var filterKeyword: String
    @Binding var sortOrder: SortOrder
    @Binding var userStatus: UserStatus
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
                
                Section("Status") {
                    Picker("Status: ", selection: $userStatus) {
                        Text("All").tag(UserStatus.all)
                        Text("Active").tag(UserStatus.active)
                        Text("Inactive").tag(UserStatus.inActive)
                    }
                    .pickerStyle(.segmented)
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
        .frame(maxWidth: geometry.size.width, maxHeight: showFilterPanel ? geometry.size.height * 0.4 : 0)
        .opacity(showFilterPanel ? 1 : 0)
        .transition(.slide)
        .animation(.easeInOut(duration: 0.5), value: showFilterPanel)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
