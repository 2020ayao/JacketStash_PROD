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
    private var tempUserSession: FirebaseAuth.User?
    
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
            self.tempUserSession = user
            //            self.userSession = user
            self.fetchUser()
            
            
            print("DEBUG: Registered User successfully")
            print("DEBUG: User is \(String(describing: self.userSession?.uid))")
            
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
                    
                    //                    self.currentUser = user
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

        let db = Firestore.firestore()
        let qRef = Firestore.firestore().collection("AVAILABLE_COAT_IDS").order(by: "coat_id")

        qRef.getDocuments { snapshot, error in

            if let snapshot = snapshot {
                let rand = Int.random(in: 1...5)
                let iD = snapshot.documents[rand-1].documentID
                print(iD)
                db.collection("AVAILABLE_COAT_IDS").document(iD).delete()
                self.currentUser?.coat_id = Int(iD) ?? -1

                let data: [String:Any] = [
                    "coat_id": self.currentUser?.coat_id as Any,
                    "fullname": self.currentUser?.fullname as Any
                ]

                db.collection("TAKEN_COAT_IDS").document(iD).setData(data)

            }
        }


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
    
//    func checkIn() {
//        print("DEBUG: checkIn function called")
//
//        Firestore.firestore().collection("AVAILABLE_COAT_IDS").order(by: "coat_id", descending: false)
//            .getDocuments { [self] qsnapshot, error in
//                if let qsnapshot = qsnapshot {
//
//
//
//                    let coat_id = qsnapshot.documents[0].documentID
//
//
//                    Firestore.firestore().collection("AVAILABLE_COAT_IDS").document(coat_id).delete() { err in
//                        if let err = err {
//                            print("Error removing document: \(err)")
//                        } else {
//                            print("Document successfully removed!")
//                        }
//                    }
//
//
//                    print("qsnapshot: ")
//                    print(qsnapshot.documents[0].documentID)
//                    self.currentUser?.coat_id = Int(coat_id) ?? -1
//
////                    guard let coat_id = currentUser?.coat_id else {return}
//
//
//
//                    let data: [String:Any] = [
//                        "coat_id": self.currentUser?.coat_id as Any,
//                        "fullname": self.currentUser?.fullname as Any
//                    ]
//
//                    print("currentUser.coat_id: \(String(describing: currentUser?.coat_id))")
//
////
//                    guard let coat_id = self.currentUser?.coat_id else {return}
//                    Firestore.firestore().collection("TAKEN_COAT_IDS")
//                        .document(String(coat_id)).setData(data) { _ in
//                            print("DEBUG: Checked \(String(describing: currentUser?.coat_id)) into TAKEN_RACK")
//                        }
//
//
//
//
//                }
//            }
//        guard let fullname = currentUser?.fullname else {return}
//        checkInService.uploadFeed(fullname: fullname, checkingIn: true) { success in
//            if success {
//                // great
//            }
//            else {
//                // let user know it failed
//            }
//        }
//    }
    

    
    
    func updateCheckInStatus(update: Bool, withUid uid: String, coat_id: Int) {
        Firestore.firestore().collection("users").document(uid).updateData(["isCheckedIn": update,
                                                                            "coat_id": coat_id])
    }
    
    func getCheckInStatus(withUid uid: String, completion: @escaping([Feed]) -> Void){
        Firestore.firestore().collection("users").document(uid)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    _ = document.data().map(String.init(describing:)) ?? "nil"
//                    print("Document data: \(dataDescription)")
                } else {
//                    print("Document does not exist")
                }
            }
    }
    
    func checkOut() {
        print("DEBUG: checkOut function called")
            
            let data: [String:Any] = [
                "coat_id": currentUser?.coat_id as Any
            ]
            
        print("CURRENT USER COAT ID PUSHED INTO AVAILABLE: \(String(describing: currentUser?.coat_id))")
            guard let coat_id = self.currentUser?.coat_id else {return}
            Firestore.firestore().collection("AVAILABLE_COAT_IDS")
                .document(String(coat_id)).setData(data) { _ in
                    print("DEBUG: Check coat back into available ids")
                }
        Firestore.firestore().collection("TAKEN_COAT_IDS").document(String(coat_id)).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        
        print("user_coat_id \(String(describing: currentUser?.coat_id)) ")
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
    
    func uploadProfileImage(_ image: UIImage)
    {
        guard let uid = tempUserSession?.uid else {return}
        
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]) { _ in
                    self.userSession = self.tempUserSession
                    self.fetchUser()
                }
        }
    }
    
}
