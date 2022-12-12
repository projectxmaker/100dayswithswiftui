//
//  ActivityListView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/17/22.
//

import SwiftUI

struct ActivityListView: View {
    @StateObject var showActivityListViewModel = ShowActivityListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(showActivityListViewModel.items, id:\.id) { item in
                    NavigationLink {
                        ActivityDetailView(showActivityDetailsVM: ShowActivityDetailsViewModel( selectedActivityItem: item, listVM: showActivityListViewModel))
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.title.bold())
                            
                            HStack {
                                Image(systemName: "flag.circle")
                                Text(item.getCompletionCountDescription())
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
                        deletedItems.append(showActivityListViewModel.items[index])
                    }
                    showActivityListViewModel.deletedItem = deletedItems[0]
                    showActivityListViewModel.showDeletionAlert.toggle()
                }
            }
            .navigationTitle("Habit Tracking")
            .toolbar {
                Button {
                    showActivityListViewModel.showActivityCreationView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                EditButton()
            }
            .sheet(isPresented: $showActivityListViewModel.showActivityCreationView) {
                ActivityCreationView()
            }
            .alert("Delete An Activity", isPresented: $showActivityListViewModel.showDeletionAlert, presenting: showActivityListViewModel.deletedItem) { deletedItem in
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
        .environmentObject(showActivityListViewModel)
    }
}

struct ActivityListView_Previewer: PreviewProvider {
    static var previews: some View {
        ActivityListView()
    }
}
