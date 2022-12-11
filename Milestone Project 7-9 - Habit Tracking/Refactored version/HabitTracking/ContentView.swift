//
//  ContentView.swift
//  HabitTracking
//
//  Created by Pham Anh Tuan on 10/15/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var activityManager = ActivityManager()
    
    var body: some View {
        ActivityListView(showActivityListViewModel: ShowActivityListViewModel(activityManager: activityManager))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
