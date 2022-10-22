//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Pham Anh Tuan on 10/22/22.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    
    // this is our content closure; we'll call this once for each item in the list
    let content: (FetchedResults<T>) -> Content
    
    init(filterKey: String, filterComparisionType: FilterComparionTypes, filterValue: String, @ViewBuilder content: @escaping (FetchedResults<T>) -> Content) {
        let comparisonType = filterComparisionType.rawValue.replacingOccurrences(of: " ", with: "").uppercased()

        _fetchRequest = FetchRequest<T>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "%K \(comparisonType)[cd] %@", filterKey, filterValue))
        self.content = content
    }
    
    var body: some View {
        List {
            self.content(fetchRequest)
        }
    }
}
