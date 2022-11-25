//
//  CheckoutViewModel.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/22/22.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift
import Foundation

class CheckoutViewModel : ObservableObject {
    
    func initiatePayment(withUid uid: String) {
        let data = ["client": "mobile",
                    "mode": "payment",
                    "amount": "199",
                    "currency": "usd"]
        Firestore.firestore().collection("customers").document(uid).collection("checkout_sessions").addDocument(data: data)
    }
}
