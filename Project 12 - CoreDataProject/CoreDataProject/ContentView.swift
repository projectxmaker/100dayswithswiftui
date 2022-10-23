//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Pham Anh Tuan on 10/21/22.
//
import Foundation
import SwiftUI
import CoreData

enum FilterComparionTypes: String, CaseIterable {
    case beginsWith = "Begins with"
    case like = "Like"
    case contains = "Contains"
    case endsWith = "Ends with"
}

enum FilterEntityTypes: String, CaseIterable {
    case country = "Country"
    case candy = "Candy"
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    
    @State private var filterComparisonType = FilterComparionTypes.beginsWith
    @State private var filterKeyword = ""
    @State private var filterForEntity = FilterEntityTypes.country
    @State private var sortOrder = SortOrder.forward
    @State private var showFilterPanel = false
    @State private var resizeResultList = false
    
    var sortDescriptorsOfCountry: [SortDescriptor<Country>] {
        [
            SortDescriptor(\.fullName, order: sortOrder),
            SortDescriptor(\.shortName, order: sortOrder)
        ]
    }
    
    var sortDescriptorsOfCandy: [SortDescriptor<Candy>] {
        [
            SortDescriptor(\.name, order: sortOrder)
        ]
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        VStack {
                            if filterForEntity == .country {
                                FilteredList(filterKeys: ["fullName", "shortName"], filterComparisionType: filterComparisonType, filterValue: filterKeyword, sortDescriptors: sortDescriptorsOfCountry) { (countries: FetchedResults<Country>) in
                                    ForEach(countries, id: \.self) { country in
                                        Section(country.wrappedFullName) {
                                            ForEach(country.candyArray, id: \.self) { candy in
                                                Text(candy.wrappedName)
                                            }
                                        }
                                    }
                                }
                            } else {
                                FilteredList(filterKeys: ["name"], filterComparisionType: filterComparisonType, filterValue: filterKeyword, sortDescriptors: sortDescriptorsOfCandy) { (candies: FetchedResults<Candy>) in
                                    ForEach(candies, id: \.self) { candy in
                                        getCandyText(candy: candy)
                                    }
                                }
                            }
                        }
                        Spacer(minLength: resizeResultList ? geometry.size.height * 1/3 : 0)
                    }

                    VStack {
                        Spacer()
                        getSearchPanel(geometry)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Filter") {
                            showFilterPanel.toggle()
                            
                            if showFilterPanel {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    resizeResultList.toggle()
                                }
                            } else {
                                resizeResultList.toggle()
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        addSamplesButton()
                    }
                }
            }
        }
    }
    
    // MARK: - Extra Functions
    
    func getCandyText(candy: Candy) -> some View {
        var countryInfo = ""
        if let country = candy.origin {
            countryInfo = country.wrappedFullName
        }
        
        return Section(candy.wrappedName) {
            Text(countryInfo)
        }
    }
    
    func addSamplesButton() -> some View {
        Button("Add") {
            let candy1 = Candy(context: moc)
            candy1.name = "Mars"
            candy1.origin = Country(context: moc)
            candy1.origin?.shortName = "UK"
            candy1.origin?.fullName = "United Kingdom"
            
            let candy2 = Candy(context: moc)
            candy2.name = "KitKat"
            candy2.origin = Country(context: moc)
            candy2.origin?.shortName = "UK"
            candy2.origin?.fullName = "United Kingdom"
            
            let candy3 = Candy(context: moc)
            candy3.name = "Twix"
            candy3.origin = Country(context: moc)
            candy3.origin?.shortName = "UK"
            candy3.origin?.fullName = "United Kingdom"
            
            let candy4 = Candy(context: moc)
            candy4.name = "Toblerone"
            candy4.origin = Country(context: moc)
            candy4.origin?.shortName = "CH"
            candy4.origin?.fullName = "Switzerland"
            
            try? moc.save()
        }
    }
    
    func getSearchPanel(_ geometry: GeometryProxy) -> some View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
