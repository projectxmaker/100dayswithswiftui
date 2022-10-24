//
//  UserManager.swift
//  FriendFace
//
//  Created by Pham Anh Tuan on 10/24/22.
//

import Foundation

class UserManager: ObservableObject {
    let userInfoURL = "https://www.hackingwithswift.com/samples/friendface.json"
    
    @Published var users = [User]()
       
    // MARK: - Extra Funcs
    func loadData(execute: @escaping (Bool) -> Void) async {
        guard let url = URL(string: userInfoURL)
        else {
            execute(false)
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedUsers = try JSONDecoder().decode([User].self, from: data)
            
            DispatchQueue.main.async {
                self.users = decodedUsers
                
                execute(true)
            }
        } catch {
            print("Invalid data \(error)")
            execute(false)
        }
        
    }
}
