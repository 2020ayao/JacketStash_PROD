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
//
//                let data: [String:Any] = [
//                    "coat_id": self.currentUser?.coat_id as Any,
//                    "fullname": self.currentUser?.fullname as Any
//                ]
//
//                db.collection("TAKEN_COAT_IDS").document(iD).setData(data)

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
                print("Population increased to \(object!)")
            }
        }
    }
    
    func checkIn4() {
//        First step: check in your own unique coat ID.
        let db = Firestore.firestore()

        db.collection("counter").document("counter").getDocument { qsnapshot, error in
            if let qsnapshot = qsnapshot {
                let number = qsnapshot.data()!["count"] as! Int
                let docData: [String: Any] = [
                    "number": number,
                    "fullname" : self.currentUser?.fullname as Any
                ]
                self.currentUser?.coat_id = number
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
    
    func checkOut4() {
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
    
    func checkIn3() {
        
        let db = Firestore.firestore()
//        let sfReference = db.collection("coat_ids").whereField("status", isEqualTo: false).
        db.collection("coat_ids").whereField("status", isEqualTo: false).getDocuments { qsnapshot, error in
            if let qsnapshot = qsnapshot {
                db.runTransaction({ (transaction, errorPointer) -> Any? in
                    let sfDocument: DocumentSnapshot
                    do {
                        try sfDocument = transaction.getDocument(qsnapshot.documents[0].reference)
                    } catch let fetchError as NSError {
                        errorPointer?.pointee = fetchError
                        return nil
                    }
                    
                    // Note: this could be done without a transaction
                    //       by updating the population using FieldValue.increment()
                    transaction.updateData(["status": true,
                                            "uid": self.userSession!.uid
                                           ], forDocument: sfDocument.reference)//qsnapshot.documents[0].reference)
                    return nil
                }) { (object, error) in
                    if let error = error {
                        print("Transaction failed: \(error)")
                    } else {
                        print("Transaction successfully committed!")
                        let dataDescription = qsnapshot.documents[0].data()["number"]
                        print(dataDescription)
                        if let coatID = Int(dataDescription as! String) {
                            self.currentUser?.coat_id = coatID
                            
                        }
                        
                        
                    }
                }
            }
        }
            
            guard let fullname = self.currentUser?.fullname else {return}
            self.checkInService.uploadFeed(fullname: fullname, checkingIn: true) { success in
                if success {
                    // great
                }
                else {
                    // let user know it failed
                }
        }
    }
    
    func checkIn2() {
        let db = Firestore.firestore()
        let query = db.collection("coat_ids").whereField("status", isEqualTo: false)
    
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if querySnapshot?.isEmpty == false {
                    print(querySnapshot?.documents[0].data())
                    print(querySnapshot?.documents[0].data()["number"])
                    
//                    db.collection("coat_ids").document("").updateData(<#T##fields: [AnyHashable : Any]##[AnyHashable : Any]#>)
//                    self.tempUID = (querySnapshot?.documents[0].documentID)!

//                    if let coat_id = querySnapshot?.documents[0].data()["number"] {
//                        let icoat_id = coat_id as? String
//                        self.currentUser?.coat_id = Int(icoat_id)
//                    }
                    let dataDescription = querySnapshot?.documents[0].data()["number"]
                    print(dataDescription)
                    if let coatID = Int(dataDescription as! String) {
                        self.currentUser?.coat_id = coatID
                    }
//                    self.currentUser?.coat_id = dataDescription


                    let dPath = querySnapshot!.documents[0].documentID
                    
                    db.collection("coat_ids").document(dPath).updateData([
                        "status" : true,
                        "uid": self.userSession?.uid])
                }
                print("DEBUG: The query was empty (all taken)")

                
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
    
    func checkOut2() {
        print(self.userSession!.uid)
        let db = Firestore.firestore()
        let query = db.collection("coat_ids").whereField("uid", isEqualTo: self.userSession?.uid)
        
//        let dPath = db.collection("coat_ids")
        
        query.getDocuments { qsnapshot, error in
            if let qsnapshot = qsnapshot {
                let dPath = qsnapshot.documents[0].documentID
                db.collection("coat_ids").document(dPath).updateData(["status" : false,
                                                                      "uid" : ""])
//                db.collection("coat_ids").document(dPath).
            }
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
//        Firestore.firestore().collection("TAKEN_COAT_IDS").document(String(coat_id)).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
        
        
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
