//
//  CheckInNotifViewModel.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/27/22.
//

import Foundation

class CheckInNotifViewModel: ObservableObject {
    let formatter = DateComponentsFormatter()
    
    
    func formatTime(withFeed feed: Feed) -> String {
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute]
        
        
        return String(formatter.string(from: feed.timestamp.dateValue().timeIntervalSinceNow)!.dropFirst())
        

    }
}
