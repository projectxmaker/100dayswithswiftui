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
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: vGridLayout, alignment: .leading, spacing: 10) {
                    ForEach(0...200, id: \.self) { id in
                        NavigationLink {
                            Text("\(id)")
                        } label: {
                            HStack {
                                VStack(alignment: .leading, content: {
                                    Text("Name \(id)")
                                        .font(.title)
                                    
                                    Text("Active")
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
            .navigationTitle("FriendFace")
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
