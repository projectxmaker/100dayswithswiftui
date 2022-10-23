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
    
    init(filterKeys: [String], filterComparisionType: FilterComparionTypes, filterValue: String, @ViewBuilder content: @escaping (FetchedResults<T>) -> Content) {
        let comparisonType = filterComparisionType.rawValue.replacingOccurrences(of: " ", with: "").uppercased()

        // create compound predicate
        var predicates = [NSPredicate]()
        
        if !filterValue.isEmpty {
            for eachFilterKey in filterKeys {
                predicates.append(NSPredicate(format: "ANY \(eachFilterKey) \(comparisonType)[cd] %@", filterValue))
            }
        }
        
        let compoundPredicate = predicates.isEmpty ? nil : NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

        // create FetchRequest
        _fetchRequest = FetchRequest<T>(
            sortDescriptors: [],
            predicate: compoundPredicate)
        self.content = content
    }
    
    var body: some View {
        List {
            self.content(fetchRequest)
        }
    }
}
