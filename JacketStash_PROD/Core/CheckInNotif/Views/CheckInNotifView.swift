//
//  CheckInNotifView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/25/22.
//

import SwiftUI

import SwiftUI

struct CheckInNotifView: View {
    let feed: Feed
    
    var body: some View {
        VStack (alignment: .leading) {
            // profile picture + Name + Tweet
            if let user = feed.user {
                HStack (alignment: .top , spacing: 12)  {
                    Circle()
                        .frame(width: 56, height: 56)
                        .foregroundColor(Color(.systemBlue))
                    
                    VStack (alignment: .leading, spacing: 4) {
                        HStack {
                            Text(user.fullname)
                                .font(.subheadline).bold()
                            
                            Text("@\(user.username)")
                                .foregroundColor(.gray)
                                .font(.caption)
                            
                            Text("2w")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        
                        if feed.checkingIn {
                            
                            Text("\(feed.fullname) checked in.")
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                        }
                        else {
                            Text("\(feed.fullname) headed out")
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                        }
                        
                    }
                }
            }
            
            Divider()
        }
    }
}

//struct CheckInNotifView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckInNotifView()
//    }
//}

