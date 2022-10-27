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
            // action buttons for tweet
            HStack {
                Button {
                    //action click
                } label: {
                    Image(systemName: "bubble.left")
                        .font(.subheadline)
                }
                Spacer()
                
                Button {
                    //action click
                } label: {
                    Image(systemName: "arrow.2.squarepath")
                        .font(.subheadline)
                }
        
                Spacer()
                
                Button {
                    //action click
                } label: {
                    Image(systemName: "heart")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button {
                    //action click
                } label: {
                    Image(systemName: "bookmark")
                        .font(.subheadline)
                }

            }
            .padding()
            .foregroundColor(.gray)
            
            Divider()
        }
    }
}

//struct CheckInNotifView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckInNotifView()
//    }
//}

