//
//  ContactListView.swift
//  Contacts
//
//  Created by Pham Anh Tuan on 10/25/22.
//

import SwiftUI

enum FilterType {
    case keyword
    case tag
}

struct ContactListView: View {
    @FetchRequest private var fetchRequest: FetchedResults<Contact>
    @Environment(\.managedObjectContext) var moc

    var filterType = FilterType.keyword
    var filterKeyword: String
    var sortOrder: SortOrder
    var userStatus: UserStatus
    
    private var contactManager = ContactManager()

    var execute: (Bool, Bool) -> Void
    
    let vGridLayout = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    init(filterType: FilterType = FilterType.keyword, filterKeyword: String, sortOrder: SortOrder, userStatus: UserStatus, execute: @escaping (Bool, Bool) -> Void) {
        self.filterType = filterType
        self.filterKeyword = filterKeyword
        self.sortOrder = sortOrder
        self.userStatus = userStatus
        
        var sortDescriptors: [SortDescriptor<Contact>] {
            [
                SortDescriptor(\.name, order: sortOrder)
            ]
        }
        
        var orKeywordPredicates = [NSPredicate]()
        var allPredicates = [NSPredicate]()
        
        switch filterType {
        case .keyword:
            let filterKeys = ["name", "address", "about"]
            
            if !filterKeyword.isEmpty {
                for eachFilterKey in filterKeys {
                    orKeywordPredicates.append(NSPredicate(format: "ANY \(eachFilterKey) like[cd] %@", "*\(filterKeyword)*"))
                }
            }
        case .tag:
            orKeywordPredicates.append(NSPredicate(format: "ANY tags.id == %@", filterKeyword))
        }
        
        if !orKeywordPredicates.isEmpty {
            allPredicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: orKeywordPredicates))
        }
        
        // user status
        if userStatus != UserStatus.all {
            let isActive = (userStatus == UserStatus.active ? true : false)
            
            let userStatusPredicate = NSPredicate(format: "ANY isActive = %d", isActive)
            
            allPredicates.append(userStatusPredicate)
        }

        let finalCompoundPredicates = allPredicates.isEmpty ? nil : NSCompoundPredicate(andPredicateWithSubpredicates: allPredicates)
        
        // create FetchRequest
        _fetchRequest = FetchRequest<Contact>(
            sortDescriptors: sortDescriptors,
            predicate: finalCompoundPredicates)
        
        self.execute = execute
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: vGridLayout, alignment: .leading, spacing: 10) {
                ForEach(fetchRequest, id: \.self) { contact in
                    NavigationLink {
                        ContactDetailsView(contactId: contact.wrappedId)
                    } label: {
                        HStack {
                            Image(systemName: "person.circle")
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(contact.wrappedName)
                                    .font(.title3)
                                Text(contact.wrappedEmail)
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .foregroundColor(contact.isActive ? .blue : .gray)
                        .padding(.trailing, 10)
                    }
                }
            }
        }
        .task {
            if fetchRequest.isEmpty {
                await contactManager.loadData(moc: moc, execute: { isLoaded, hasData in
                    // always return true at this phase means the process finished
                    execute(isLoaded, hasData)
                })
            } else {
                execute(true, true)
            }
        }

    }
}
