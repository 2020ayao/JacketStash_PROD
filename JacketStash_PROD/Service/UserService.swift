//
//  UserService.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import Firebase
import FirebaseFirestoreSwift

struct UserService {
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        print("DEBUG: Fetch user info..")
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else {return}
                
                guard let user = try? snapshot.data(as: User.self) else {return}
                
                print("DEBUG: username is \(user.username)")
                print("DEBUG: email is \(user.email)")
                
                completion(user)
                
                
            }
    }
}
