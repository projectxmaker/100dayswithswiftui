//
//  FilterPanel.swift
//  CoreDataProject
//
//  Created by Pham Anh Tuan on 10/23/22.
//

import CoreData
import SwiftUI

struct FilterPanel: View {
    @Binding var filterComparisonType: FilterComparionTypes
    @Binding var filterKeyword: String
    @Binding var filterForEntity: FilterEntityTypes
    @Binding var sortOrder: SortOrder
    @Binding var showFilterPanel: Bool
    var geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Form {
                Section {
                    VStack {
                        HStack {
                            Picker("", selection: $filterComparisonType) {
                                ForEach(FilterComparionTypes.allCases, id: \.self) { comparionType in
                                    Text(comparionType.rawValue)
                                }
                            }
                            .overlay {
                                HStack {
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.subheadline)
                                    Text(filterComparisonType.rawValue)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .background(.white)
                            }
                            .frame(width: 150)
                            .padding(.trailing, -30)
                            
                            TextField(text: $filterKeyword) {
                                Text("Keyword")
                            }
                            .textInputAutocapitalization(.never)
                        }
                        
                        Picker("", selection: $filterForEntity) {
                            ForEach(FilterEntityTypes.allCases, id: \.self) { eachEntity in
                                Text(eachEntity.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                } header: {
                    Text("Search")
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
        .frame(maxHeight: showFilterPanel ? geometry.size.height/3 : 0)
        .opacity(showFilterPanel ? 1 : 0)
        .transition(.slide)
        .animation(.easeInOut(duration: 0.5), value: showFilterPanel)
        .layoutPriority(showFilterPanel ? 1 : 0)
    }
}
