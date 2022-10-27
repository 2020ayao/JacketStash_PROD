//
//  Feed.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/27/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Feed: Identifiable, Decodable {
    @DocumentID var id: String?
    let fullname: String
    let timestamp: Timestamp
    let uid: String
    var checkingIn: Bool
    
    var user: User?
    
}
