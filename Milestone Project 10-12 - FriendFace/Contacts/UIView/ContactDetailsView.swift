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
                    
                    ScrollableInfo(label: "About", content: contactDetail.wrappedAbout, geometry: geometry)
                    
                    TextFieldInfo(label: "Registered", content: contactDetail.wrappedRegistered, geometry: geometry)
                    
                    TextFieldInfo(label: "Tags", content: contactDetail.wrappedTags, geometry: geometry)
                    
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
