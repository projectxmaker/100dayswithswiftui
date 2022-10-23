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
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        displayResults()
                        Spacer(minLength: resizeResultList ? geometry.size.height * 1/3 : 0)
                    }

                    VStack {
                        Spacer()
                        FilterPanel(
                            filterComparisonType: $filterComparisonType,
                            filterKeyword: $filterKeyword,
                            filterForEntity: $filterForEntity,
                            sortOrder: $sortOrder,
                            showFilterPanel: $showFilterPanel,
                            geometry: geometry)
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
    
    private func displayResults() -> some View {
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
        
        return VStack {
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
    }
    
    private func getCandyText(candy: Candy) -> some View {
        var countryInfo = ""
        if let country = candy.origin {
            countryInfo = country.wrappedFullName
        }
        
        return Section(candy.wrappedName) {
            Text(countryInfo)
        }
    }
    
    private func addSamplesButton() -> some View {
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
            
            let candy5 = Candy(context: moc)
            candy5.name = "Mè Xửng Huế"
            candy5.origin = Country(context: moc)
            candy5.origin?.shortName = "VN"
            candy5.origin?.fullName = "Vietnam"
            
            let candy6 = Candy(context: moc)
            candy6.name = "Kẹo Cu Đơ"
            candy6.origin = Country(context: moc)
            candy6.origin?.shortName = "VN"
            candy6.origin?.fullName = "Vietnam"
            
            let candy7 = Candy(context: moc)
            candy7.name = "Kẹo Dừa Bến Tre"
            candy7.origin = Country(context: moc)
            candy7.origin?.shortName = "VN"
            candy7.origin?.fullName = "Vietnam"
            
            let candy8 = Candy(context: moc)
            candy8.name = "Mứt Rong Sụn Phan Rang"
            candy8.origin = Country(context: moc)
            candy8.origin?.shortName = "VN"
            candy8.origin?.fullName = "Vietnam"
            
            let candy9 = Candy(context: moc)
            candy9.name = "Kẹo Sìu Châu Nam Định"
            candy9.origin = Country(context: moc)
            candy9.origin?.shortName = "VN"
            candy9.origin?.fullName = "Vietnam"
            
            try? moc.save()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
