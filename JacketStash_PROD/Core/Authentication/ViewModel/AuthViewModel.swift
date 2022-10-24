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
    @Published var isCheckedIn = false
    @Published var isCheckedOut = false
    //@Published var coat_id: Int
    
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
                "isCheckedIn": isCheckedIn,
                "coat_id": -1
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
    
    func checkIn() {
        print("DEBUG: checkIn function called")
        
        if let user = Auth.auth().currentUser {
            let docRef = Firestore.firestore().collection("AVAILABLE_COAT_IDS").order(by: "coat_id", descending: false)
                .getDocuments { qsnapshot, error in
                if let qsnapshot = qsnapshot {
                    self.currentUser?.coat_id = Int(qsnapshot.documents[0].documentID)!
                    Firestore.firestore().collection("AVAILABLE_COAT_IDS").document().delete()
                    
                }
            }
            
            let data: [String:Any] = [
                "coat_id": currentUser?.coat_id,
                "uid": user.uid
            ]
            
            print("currentUser.coat_id: \(currentUser?.coat_id)")
            
            Firestore.firestore().collection("taken_COAT_IDS")
                .document(String(self.currentUser!.coat_id)).setData(data) { _ in
                    print("DEBUG: Did check coat id back into available coat ids")
                }
            
        }
        isCheckedIn.toggle()
    }
    
    func checkOut() {
        print("DEBUG: checkOut function called")
        
        
        if let user = Auth.auth().currentUser {
            
            let coat_id: [String:Any] = [
                "coat_id": currentUser?.coat_id
            ]
            
            print("CURRENT USER COAT ID PUSHED INTO AVAILABLE: \(currentUser?.coat_id)")
            
            Firestore.firestore().collection("AVAILABLE_COAT_IDS")
                .document(String(currentUser!.coat_id)).setData(coat_id) { _ in
                    print("DEBUG: Did check coat id back into available coat ids")
                }
        }
        isCheckedOut.toggle()
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else {return}
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
}
