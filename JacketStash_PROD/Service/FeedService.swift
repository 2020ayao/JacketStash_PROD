//
//  FeedService.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/27/22.
//

import Foundation
import Firebase

struct FeedService {
    
    func uploadFeed(fullname: String, checkingIn: Bool, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let data = [
            "uid": uid,
            "fullname": fullname,
            "checkingIn": checkingIn,
            "timestamp": Timestamp(date: Date())
        ] as [String: Any]
        
        Firestore.firestore().collection("feed").document()
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: Failed to upload checkin: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                completion(true)
            }
        
    }

    
    func fetchFeed(completion: @escaping([Feed]) -> Void) {
        Firestore.firestore().collection("feed")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else {return}
                let feed = documents.compactMap({try? $0.data(as: Feed.self) })
                //print(feed)
                completion(feed)
            }
    }
}
