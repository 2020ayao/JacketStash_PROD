//
//  CheckedInViewModel.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/22/22.
//

import SwiftUI
import Firebase

class CheckedInViewModel: ObservableObject {
    
    @Published var feed = [Feed]()
    
    let feedservice = FeedService()
    let userService = UserService()
    
    init() {
        fetchFeed()
    }
    
    func fetchFeed() {
        feedservice.fetchFeed { feed in
            self.feed = feed
            for i in 0 ..< feed.count {
                let uid = feed[i].uid
                self.userService.fetchUser(withUid: uid) { user in
                    self.feed[i].user = user
                }
            }
            //print("DEBUG: \(self.feed)")
        }
    }
}
