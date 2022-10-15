//
//  ContentView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI



struct ContentView: View {
    @State private var showActivityCreationView = false
    
    @StateObject private var activities = Activities()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(activities.list, id:\.id) { item in
                    NavigationLink {
                        ActivityDetailView(activities: activities, selectedActivityItem: item)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.title.bold())
                            Text(item.description)
                            Text("Completion: \(item.getCompletionCountDescription())")
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
                ActivityCreationView(activities: activities)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
