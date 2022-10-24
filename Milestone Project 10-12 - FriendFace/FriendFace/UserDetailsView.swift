//
//  UserDetailsView.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import SwiftUI

struct UserDetailsView: View {
    var user: User
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .center, spacing: 0) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / 2)
                            .foregroundColor(user.isActive ? .blue : .gray)
                        
                        Text(user.name)
                            .font(.largeTitle)
                        
                        Text("\(user.age) years old")
                            .font(.caption)
                    }
                    
                    TextFieldInfo(label: "Company", content: user.company, geometry: geometry)
                    TextFieldInfo(label: "Email", content: user.email, geometry: geometry)
                    TextFieldInfo(label: "Address", content: user.address, geometry: geometry)
                    ScrollableInfo(label: "About", content: user.about, geometry: geometry)
                    TextFieldInfo(label: "Registered", content: user.wrappedRegistered, geometry: geometry)
                    TextFieldInfo(label: "Tags", content: user.tags.joined(separator: ", "), geometry: geometry)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Friends")
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(user.friends, id: \.id) { friend in
                                    NavigationLink {
                                        Text(friend.name)
                                    } label: {
                                        Text(friend.name)
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
