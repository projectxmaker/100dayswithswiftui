//
//  ContentView.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import SwiftUI

enum UserStatus {
    case active
    case inActive
    case all
}

struct ContentView: View {
    @State private var showProgressView = true
    @State private var filterKeyword = ""
    @State private var sortOrder = SortOrder.forward
    @State private var userStatus = UserStatus.all
    @State private var showFilterPanel = false
    @State private var resizeResultList = false
    @State private var hasData = false
    
    @Environment(\.managedObjectContext) var moc
    private var contactManager = ContactManager()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                
                ZStack {
                    if showProgressView {
                        ProgressView()
                    } else {
                        if !hasData {
                            Text("No data available!")
                        }
                    }
                    
                    VStack {
                        ContactListView(filterKeyword: filterKeyword, sortOrder: sortOrder, userStatus: userStatus) { isLoaded, hasData in
                            showProgressView = !isLoaded
                            self.hasData = hasData
                        }
                        .padding()
                        
                        Spacer(minLength: resizeResultList ? geometry.size.height * 0.38 : 0)
                    }
                    
                    VStack {
                        Spacer()
                        FilterPanelView(
                            filterKeyword: $filterKeyword,
                            sortOrder: $sortOrder,
                            userStatus: $userStatus,
                            showFilterPanel: $showFilterPanel,
                            geometry: geometry
                        )
                    }
                }
                .navigationTitle("Contacts")
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
                }
            }
        }
        .task {
            await contactManager.loadData(moc: moc, execute: { isLoaded, hasData in
                // if app is showing data, just leave it like that, otherwise depending on the data have just been loaded from remote api.
                self.hasData = self.hasData ? true : hasData
            })
        }
    }
}
