//
//  AuthViewModel.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/18/22.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    @Published var currentUser: User?
    
    private let service = UserService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    func login(withEmail email: String, password: String) {
        print("DEBUG: Login with email \(email)")
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to signin with error \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else {return}
            self.userSession = user
            print("DEBUG: Logged User in successfully")
            print("DEBUG: User is \(String(describing: self.userSession?.uid))")
        }
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String, isCheckedIn: Bool) {
        print("DEBUG: Register with email \(email)")
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                print(error)
                return
            }
            guard let user  = result?.user else {return}
            self.userSession = user
            
            print("DEBUG: Registered User successfully")
            print("DEBUG: User is \(self.userSession?.uid)")
            
            let data = [
                "email": email,
                "username": username.lowercased(),
                "fullname": fullname,
                "uid": user.uid,
                "isCheckedIn": isCheckedIn
            ]
            
            Firestore.firestore().collection("users")
                .document(user.uid).setData(data) { _ in
                    self.didAuthenticateUser = true
                    print("DEBUG: Did upload user data...")
                }
            
        }
    }
    
    func signOut() {
        userSession = nil
        try? Auth.auth().signOut()
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else {return}
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
}
