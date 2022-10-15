//
//  ContentView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showActivityCreationView = false
    let columnLayout: [GridItem] = [
        GridItem(GridItem.Size.flexible(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0...10, id:\.self) { item in
                    NavigationLink {
                        ActivityDetailView()
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                            Text("Hello, world!")
                            
                            Spacer()
                        }
                    }
                }
                .onDelete { indexSet in
                    print("do something")
                }
            }
            .navigationTitle("Habit Tracking")
            .toolbar {
                Button {
                    showActivityCreationView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showActivityCreationView) {
                ActivityCreationView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
