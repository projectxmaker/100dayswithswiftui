//
//  ScrollableItems.swift
//  Contacts
//
//  Created by Pham Anh Tuan on 10/25/22.
//

import SwiftUI

struct ScrollableItems: View {
    var label: String
    var items: [ContactFriend]
    var avatarSystemName = "person.circle"
    var axis: Axis.Set = .horizontal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Friends")
                .font(.headline)
            ScrollView(axis, showsIndicators: false) {
                HStack {
                    ForEach(items, id: \.id) { friend in
                        NavigationLink {
                            ContactDetailsView(contactId: friend.wrappedId)
                        } label: {
                            HStack {
                                Image(systemName: avatarSystemName)
                                    .font(.title)
                                Text(friend.wrappedName)
                            }
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
