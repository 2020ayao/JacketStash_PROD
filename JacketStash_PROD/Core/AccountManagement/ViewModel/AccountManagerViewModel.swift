//
//  AccountManagerViewModel.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/28/22.
//

import Foundation
import Firebase

class AccountManagerViewModel: ObservableObject {
    
    func deleteAccount(withUid uid: String, completion: @escaping() -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).delete()
    }
    
    func deactivateAccount(withUid uid: String, completion: @escaping() -> Void) {
        
    }
}
