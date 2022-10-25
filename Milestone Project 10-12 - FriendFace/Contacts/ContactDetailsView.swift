//
//  UserDetailsView.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import SwiftUI

struct ContactDetailsView: View {
    var contact: Contact
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .center, spacing: 0) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / 2)
                            .foregroundColor(contact.isActive ? .blue : .gray)
                        
                        Text(contact.wrappedName)
                            .font(.largeTitle)
                        
                        Text("\(contact.age) years old")
                            .font(.caption)
                    }
                    
                    TextFieldInfo(label: "Company", content: contact.wrappedCompany, geometry: geometry)
                    TextFieldInfo(label: "Email", content: contact.wrappedEmail, geometry: geometry)
                    TextFieldInfo(label: "Address", content: contact.wrappedAddress, geometry: geometry)
                    ScrollableInfo(label: "About", content: contact.wrappedAbout, geometry: geometry)
                    TextFieldInfo(label: "Registered", content: contact.wrappedRegistered, geometry: geometry)
                    TextFieldInfo(label: "Tags", content: contact.wrappedTags, geometry: geometry)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Friends")
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(contact.friendsArray, id: \.id) { friend in
                                    NavigationLink {
                                        Text(friend.wrappedName)
                                    } label: {
                                        Text(friend.wrappedName)
                                            .padding()
                                            .frame(height: 40)
                                            .foregroundColor(Color.white)
                                            .background(Color.blue)
                                            .clipShape(Capsule(style: .continuous))
                                            .shadow(color: Color.gray, radius: 2, x: 0, y: 2)
                                    }
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
                        .background(RoundedRectangle(cornerRadius: 10).fill(.thinMaterial))
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}
