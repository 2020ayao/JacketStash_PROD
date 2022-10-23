//
//  User.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import FirebaseFirestoreSwift

struct User: Identifiable, Decodable{
    @DocumentID var id: String?
    let username: String
    let fullname: String
//    let profileImageUrl: String
    let email: String
    //var isCheckedIn: Bool
    
}

