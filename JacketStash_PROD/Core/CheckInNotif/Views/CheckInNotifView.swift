//
//  CheckInNotifView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/25/22.
//

import SwiftUI

import Kingfisher

struct CheckInNotifView: View {
    let feed: Feed
    let viewModel: CheckInNotifViewModel
    
    
    
    var body: some View {
        
        
        VStack (alignment: .leading) {
            // profile picture + Name + Tweet
            if let user = feed.user {
                HStack (alignment: .top , spacing: 12)  {
                    KFImage(URL(string: user.profileImageUrl))
//                    Circle()
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color(.systemBlue))
                    
                    VStack (alignment: .leading, spacing: 4) {
                        HStack {
                            Text(user.fullname)
                                .font(.subheadline).bold()
                            
                            Text("@\(user.username)")
                                .foregroundColor(.gray)
                                .font(.caption)
                            
//                            Text("\(feed.timestamp.dateValue().formatted(.dateTime.minute(.twoDigits)))")
//                                .foregroundColor(.gray)
//                                .font(.caption)
                            
//                            Text(computeNewDate(from: feed.timestamp.dateValue(), to:Date.now))
//                                .foregroundColor(.gray)
//                                .font(.caption)
                            
                            Text(viewModel.formatTime(withFeed: feed))
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
    
    
    func computeNewDate(from fromDate: Date, to toDate: Date) -> Date {
         let delta = toDate - fromDate // `Date` - `Date` = `TimeInterval`
         let today = Date()
         if delta < 0 {
             return today
         } else {
             return today + delta // `Date` + `TimeInterval` = `Date`
         }
    }
    
}



extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

//struct CheckInNotifView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckInNotifView(feed: feed, viewModel: viewMod)
//    }
//}

