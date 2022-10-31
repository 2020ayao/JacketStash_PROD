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
    @Published var currentUser: User? = nil
    @Published var checkedIn = false
    @Published var checkedOut = false
    //@Published var coat_id: Int
    
    private let service = UserService()
    private let checkInService = FeedService()
    
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
            self.fetchUser()
            print("DEBUG: Logged User in successfully")
            print("DEBUG: User is \(String(describing: self.userSession?.uid))")
        }
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String, isCheckedIn: Bool) {
        print("DEBUG: Regixxster with email \(email)")
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                print(error)
                return
            }
            guard let user  = result?.user else {return}
            self.userSession = user
            self.fetchUser()
            
            
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
                    
                    //self.currentUser = user
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
        
        
        Firestore.firestore().collection("AVAILABLE_COAT_IDS").order(by: "coat_id", descending: false)
            .getDocuments { [self] qsnapshot, error in
                if let qsnapshot = qsnapshot {
                    print("qsnapshot: ")
                    print(qsnapshot.documents[0].documentID)
                    self.currentUser?.coat_id = Int(qsnapshot.documents[0].documentID) ?? -1
                    
                    let data: [String:Any] = [
                        "coat_id": self.currentUser?.coat_id,
                        "fullname": self.currentUser?.fullname
                    ]
                    
                    print("currentUser.coat_id: \(currentUser?.coat_id)")
                    
//
                    guard let coat_id = self.currentUser?.coat_id else {return}
                    Firestore.firestore().collection("TAKEN_COAT_IDS")
                        .document(String(coat_id)).setData(data) { _ in
                            print("DEBUG: Did check coat id back into taken coat ids")
                        }
                    
                    print("final check")
                    print(currentUser?.coat_id)
                    
                    Firestore.firestore().collection("AVAILABLE_COAT_IDS").document(String(self.currentUser!.coat_id)).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    
                    
                }
            }
        
        
        
        //Firestore.firestore().collection("AVAILABLE_COAT_IDS").document().delete()
//        self.checkedIn = true
//        checkedOut.toggle()
        guard let fullname = currentUser?.fullname else {return}
        checkInService.uploadFeed(fullname: fullname, checkingIn: true) { success in
            if success {
                // great
            }
            else {
                // let user know it failed
            }
        }
    }
    
    
    func updateCheckInStatus(update: Bool, withUid uid: String) {
        Firestore.firestore().collection("users").document(uid).updateData(["isCheckedIn": update])
    }
    
    func getCheckInStatus(withUid uid: String, completion: @escaping([Feed]) -> Void){
        Firestore.firestore().collection("users").document(uid)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            }
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
            
            Firestore.firestore().collection("TAKEN_COAT_IDS").document(String(self.currentUser!.coat_id)).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
//        checkedIn.toggle()
//        checkedOut = true
        
        guard let fullname = currentUser?.fullname else {return}
        checkInService.uploadFeed(fullname: fullname, checkingIn: false) { success in
            if success {
                //great
            } else {
                //let user know they had an error
            }
        }
        
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else {return}
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
    
}
