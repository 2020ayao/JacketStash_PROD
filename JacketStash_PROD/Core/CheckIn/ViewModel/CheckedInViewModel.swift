//
//  CheckedInViewModel.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/22/22.
//

import SwiftUI
import Firebase

class CheckedInViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    @Published var currentUser: User?
    
    private let service = UserService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    
    
//    func checkIn() {
//        Firestore.firestore().collection("users")
//            .document(user.uid).updateData({"isCheckedIn" : true}) { _ in
//                self.didAuthenticateUser = true
//                print("DEBUG: Did update checkedIn ...")
//            }
//    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else {return}
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
}
