//
//  ContentView.swift
//  HotProspects
//
//  Created by Pham Anh Tuan on 11/9/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var prospects = Prospects()
    @StateObject var fakeContacts = FakeContacts()

    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        .environmentObject(prospects)
        .environmentObject(fakeContacts)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
