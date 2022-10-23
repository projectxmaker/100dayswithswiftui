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
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    if filterForEntity == .country {
                        FilteredList(filterKeys: ["fullName", "shortName"], filterComparisionType: filterComparisonType, filterValue: filterKeyword) { (countries: FetchedResults<Country>) in
                            ForEach(countries, id: \.self) { country in
                                Section(country.wrappedFullName) {
                                    ForEach(country.candyArray, id: \.self) { candy in
                                        Text(candy.wrappedName)
                                    }
                                }
                            }
                        }
                    } else {
                        FilteredList(filterKeys: ["name"], filterComparisionType: filterComparisonType, filterValue: filterKeyword) { (candies: FetchedResults<Candy>) in
                            ForEach(candies, id: \.self) { candy in
                                getCandyText(candy: candy)
                            }
                        }
                    }

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
                    }
                    .frame(maxHeight: geometry.size.height/5)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
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
        
        return VStack (alignment: .leading) {
            Text(candy.wrappedName)
                .font(.title)
            Text(countryInfo)
                .font(.caption)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
