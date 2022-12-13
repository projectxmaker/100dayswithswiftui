//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Pham Anh Tuan on 12/12/22.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)

            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundColor(.secondary)
        }
    }
}

enum SortType {
    case accending, decending
}

struct ContentView: View {
    @State private var searchText = ""
    @StateObject var favorites = Favorites()
    @State private var sortByName: SortType?
    @State private var sortByCountry: SortType?
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")

    var filteredResorts: [Resort] {
        var list = resorts
        
        if !searchText.isEmpty {
            list = resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let sortByName = sortByName {
            list.sort { lhs, rhs in
                switch sortByName {
                case .decending:
                    return lhs.name > rhs.name
                default:
                    return lhs.name < rhs.name
                }
            }
        }
        
        if let sortByCountry = sortByCountry {
            list.sort { lhs, rhs in
                switch sortByCountry {
                case .decending:
                    return lhs.country > rhs.country
                default:
                    return lhs.country < rhs.country
                }
            }
        }
        
        return list
    }
    
    func switchSortByName() {
        sortByName = sortByName == .accending ? .decending : .accending
        sortByCountry = nil
    }
    
    func switchSortByCountry() {
        sortByCountry = sortByCountry == .accending ? .decending : .accending
        sortByName = nil
    }
    
    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        switchSortByName()
                    } label: {
                        HStack(spacing: 0) {
                            Image(systemName: "flag.fill")
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.caption2)
                        }
                        .font(.caption)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        switchSortByCountry()
                    } label: {
                        HStack(spacing: 0) {
                            Image(systemName: "textformat.size.smaller")
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.caption2)
                        }
                    }
                }
            }
            
            WelcomeView()
        }
        .phoneOnlyStackNavigationView()
        .environmentObject(favorites)

    }
}

extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
