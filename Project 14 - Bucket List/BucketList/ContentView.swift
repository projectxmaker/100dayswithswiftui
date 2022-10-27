//
//  ContentView.swift
//  BucketList
//
//  Created by Pham Anh Tuan on 10/27/22.
//

import SwiftUI

struct User: Codable {
    var name: String
}

struct ContentView: View {
    var body: some View {
        Text("Hello World")
            .onTapGesture {
                let arrUsers = [
                    User(name: "Nam"),
                    User(name: "Phuong"),
                    User(name: "Bee"),
                    User(name: "Vy")
                ]
                
                let url = FileManager.default.encodeJSON("users", fileData: arrUsers)
                
                if let _ = url {
                    let users: [User] = FileManager.default.decodeJSON("users")
                    
                    print(users)
                } else {
                    print("oops")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
