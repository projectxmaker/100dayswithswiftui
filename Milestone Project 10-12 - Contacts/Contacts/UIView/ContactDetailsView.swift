//
//  UserDetailsView.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import SwiftUI

struct ContactDetailsView: View {
    @FetchRequest var fetchRequest: FetchedResults<Contact>
    
    var contactId: String
    
    private var contactDetail: Contact {
        return getContactDetail()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .center, spacing: 0) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / 2)
                            .foregroundColor(contactDetail.isActive ? .blue : .gray)
                        
                        Text(contactDetail.wrappedName)
                            .font(.largeTitle)
                        
                        Text("\(contactDetail.age) years old")
                            .font(.caption)
                    }
                    
                    TextFieldInfo(label: "Company", content: contactDetail.wrappedCompany, geometry: geometry)
                    
                    TextFieldInfo(label: "Email", content: contactDetail.wrappedEmail, geometry: geometry)
                    
                    TextFieldInfo(label: "Address", content: contactDetail.wrappedAddress, geometry: geometry)
                    
                    ScrollableInfo(label: "About", geometry: geometry) {
                        Text(contactDetail.wrappedAbout)
                    }
                    
                    TextFieldInfo(label: "Registered", content: contactDetail.wrappedRegistered, geometry: geometry)
                    
                    ScrollableInfo(label: "Tags", geometry: geometry, axis: .vertical, heightRatio: 0.1) {
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]) {
                            ForEach(contactDetail.tagsArray, id: \.id) { tag in
                                NavigationLink {
                                    ContactListView(filterType: .tag, filterKeyword: tag.wrappedId, sortOrder: SortOrder.forward, userStatus: .all) { isLoaded, hasData in
                                            // all done
                                    }
                                    .navigationTitle("Tag \"\(tag.wrappedName)\"")
                                } label: {
                                    Text(tag.wrappedName)
                                        .underline(true, color: Color.accentColor)
                                }
                            }
                        }
                    }
                    
                    ScrollableItems(label: "Friends", items: contactDetail.friendsArray)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    
    // MARK - Extra Functions
    func getContactDetail() -> Contact {
        if !fetchRequest.isEmpty {
            guard let contact = fetchRequest.first else {
                return Contact()
            }
            
            return contact
        } else {
            return Contact()
        }
    }
}

extension ContactDetailsView {
    init(contactId: String) {
        self.contactId = contactId
        
        let predicate = NSPredicate(format: "ANY id == %@", contactId)
        _fetchRequest = FetchRequest<Contact>(sortDescriptors: [], predicate: predicate)
    }
}
