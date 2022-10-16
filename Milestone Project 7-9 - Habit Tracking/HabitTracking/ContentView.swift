//
//  ContentView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showActivityCreationView = false
    @State private var showDeletionAlert = false
    @State private var deletedItem: ActivityItem?
    
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
                    var deletedItems = [ActivityItem]()
                    for index in indexSet {
                        deletedItems.append(activities.list[index])
                    }
                    deletedItem = deletedItems[0]
                    showDeletionAlert.toggle()
                }
            }
            .navigationTitle("Habit Tracking")
            .toolbar {
                Button {
                    showActivityCreationView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                EditButton()
            }
            .sheet(isPresented: $showActivityCreationView) {
                ActivityCreationView(createActivityVM: CreateActivityViewModel(activities: activities))
            }
            .alert("Delete An Activity", isPresented: $showDeletionAlert, presenting: deletedItem) { deletedItem in
                Button(role: .destructive) {
                    activities.deleteActivityById(deletedItem.id)
                } label: {
                    Text("Delete")
                }
            } message: { deletedItem in
                Text("Do you want to delete this Activity:\n \"\(deletedItem.title)\"")
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
