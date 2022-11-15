//
//  AuthViewModel.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/18/22.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    @Published var currentUser: User? = nil
    private var tempUserSession: FirebaseAuth.User?
    private var tempUID: String = ""
    
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
    
  
    func updateCounter() {
        let db = Firestore.firestore()
        let sfReference = db.collection("counter").document("counter")

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(sfReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let oldPopulation = sfDocument.data()?["count"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }
            // Note: this could be done without a transaction
            //       by updating the population using FieldValue.increment()
            let newPopulation = oldPopulation + 1
            
            guard newPopulation <= 1000 else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Population \(newPopulation) too big"]
                )
                errorPointer?.pointee = error
                return nil
            }

            transaction.updateData(["count": newPopulation], forDocument: sfReference)
            return newPopulation
        }) { (object, error) in
            if let error = error {
                print("Error updating population: \(error)")
            } else {
                print("Population increased to \(object!)")
//                self.currentUser?.coat_id = object as! Int-1
                self.updateCheckInStatus(update: true, withUid: self.userSession!.uid, coat_id: object as! Int - 1)
                
            }
        }
    }
    
    func decrementCounter() {
        let db = Firestore.firestore()
        let sfReference = db.collection("counter").document("counter")

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(sfReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let oldPopulation = sfDocument.data()?["count"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }

            // Note: this could be done without a transaction
            //       by updating the population using FieldValue.increment()
            let newPopulation = oldPopulation - 1
            guard newPopulation >= 1 else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Population \(newPopulation) too big"]
                )
                errorPointer?.pointee = error
                return nil
            }

            transaction.updateData(["count": newPopulation], forDocument: sfReference)
            return newPopulation
        }) { (object, error) in
            if let error = error {
                print("Error updating population: \(error)")
            } else {
                print("Population decreased to \(object!)")
                self.updateCheckInStatus(update: false, withUid: self.userSession!.uid, coat_id: 0)

            }
        }
    }
    
    func checkIn() {
//        First step: check in your own unique coat ID.
        let db = Firestore.firestore()

        db.collection("counter").document("counter").getDocument { qsnapshot, error in
            if let qsnapshot = qsnapshot {
                let number = qsnapshot.data()!["count"] as! Int
                let docData: [String: Any] = [
                    "number": number,
                    "fullname" : self.currentUser?.fullname as Any
                ]
//                self.currentUser?.coat_id = number
                db.collection("coat_ids").document(self.userSession!.uid).setData(docData) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
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

        updateCounter()
    }
    
    func checkOut() {
        let db = Firestore.firestore()
        if let uid = self.userSession?.uid {
            db.collection("coat_ids").document(uid).delete()
        }
        guard let fullname = currentUser?.fullname else {return}
        checkInService.uploadFeed(fullname: fullname, checkingIn: false) { success in
            if success {
                // great
            }
            else {
                // let user know it failed
            }
        }
        decrementCounter()

    }

    
    
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
    
    func updateProfileInformation(withUid uid: String, withName fullname: String, withUserName username: String) {
        Firestore.firestore().collection("users").document(uid).updateData([
                                                                            "fullname" : fullname,
                                                                            "username" : username
                                                                           ])
        self.fetchUser()
    }
    
}
