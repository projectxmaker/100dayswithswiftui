//
//  ContentView.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import SwiftUI

struct ContentView: View {
    private var contactManager = ContactManager()
    @State private var showProgressView = true
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var fetchRequest: FetchedResults<Contact>
    
    let vGridLayout = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                if showProgressView {
                    ProgressView()
                } else {
                    if fetchRequest.isEmpty {
                        Text("No data available!")
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: vGridLayout, alignment: .leading, spacing: 10) {
                        ForEach(fetchRequest, id: \.self) { contact in
                            NavigationLink {
                                ContactDetailsView(contact: contact)
                            } label: {
                                HStack {
                                    Image(systemName: "person.circle")
                                        .font(.title)
                                    
                                    Text(contact.wrappedName)
                                        .font(.title3)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                }
                                .foregroundColor(contact.isActive ? .blue : .gray)
                                .padding(.trailing, 10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Contacts")
            .padding()
            .task {
                if fetchRequest.isEmpty {
                    await contactManager.loadData(moc: moc, execute: { isLoaded in
                        showProgressView = false
                    })
                } else {
                    showProgressView = false
                }
            }
        }
    }
}

extension ContentView {
    init() {
        _fetchRequest = FetchRequest(sortDescriptors: [])
    }
}
