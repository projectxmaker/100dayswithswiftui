//
//  ContentView.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import SwiftUI

struct ContentView: View {
    let vGridLayout: [GridItem] = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    @StateObject var userManager = UserManager()
    @State private var showProgressView = true
    
    var body: some View {
        NavigationView {
            ZStack {
                if showProgressView {
                    ProgressView()
                }
                
                ScrollView {
                    LazyVGrid(columns: vGridLayout, alignment: .leading, spacing: 10) {
                        ForEach(userManager.users, id: \.id) { user in
                            NavigationLink {
                                Text("\(user.name)")
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, content: {
                                        Text(user.name)
                                            .font(.title)
                                        
                                        Text(user.isActive ? "Active" : "Inactive")
                                            .font(.subheadline)
                                    })
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                }
                                .padding(.trailing, 10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("FriendFace")
            .padding()
            .task {
                await userManager.loadData(execute: { isLoaded in
                    showProgressView = false
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
