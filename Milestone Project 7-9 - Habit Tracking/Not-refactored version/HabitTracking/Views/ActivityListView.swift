//
//  ActivityListView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/17/22.
//

import SwiftUI

struct ActivityListView: View {
    @State private var showActivityCreationView = false
    @State private var showDeletionAlert = false
    @State private var deletedItem: ActivityItem?
    
    @StateObject var showActivityListViewModel: ShowActivityListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(showActivityListViewModel.getActivities(), id:\.id) { item in
                    NavigationLink {
                        ActivityDetailView(showActivityDetailsVM: ShowActivityDetailsViewModel(activityManager: showActivityListViewModel.getActivityManager(), selectedActivityItem: item))
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.title.bold())
                            
                            HStack {
                                Image(systemName: "flag.circle")
                                //Text("Completion: \(item.getCompletionCountDescription())")
                                Text("\(item.getCompletionCountDescription())")
                                Spacer()
                            }
                            
                            Text(item.description)
                                .font(.caption)
                        }
                    }
                }
                .onDelete { indexSet in
                    var deletedItems = [ActivityItem]()
                    for index in indexSet {
                        deletedItems.append(showActivityListViewModel.getActivities()[index])
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
                ActivityCreationView(createActivityVM: CreateActivityViewModel(activityManager: showActivityListViewModel.getActivityManager()))
            }
            .alert("Delete An Activity", isPresented: $showDeletionAlert, presenting: deletedItem) { deletedItem in
                Button(role: .destructive) {
                    showActivityListViewModel.deleteActivityById(deletedItem.id)
                } label: {
                    Text("Delete")
                }
            } message: { deletedItem in
                Text("Do you want to delete this Activity:\n \"\(deletedItem.title)\"")
            }
            .navigationViewStyle(.stack)
        }
    }
}
