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
        
        let (d,h,m) = secondsToHoursMinutesSeconds(Int(Date().millisecondsSince1970)-Int(feed.timestamp.seconds))
        
        
        
        if d != 0 {
            if d == 1{
                return "\(d) day ago"
            }
            else{
                return "\(d) days ago"
            }
        }
        if h != 0 {
            if h == 1 {
                return "\(h) hour ago"
            }
            return "\(h) hours ago"
        }
        
        if m != 0 {
            return "\(m)m ago"
        }
        
        else {
            return "1m ago"
        }
       
        
        
//        return String(formatter.string(from: feed.timestamp.dateValue().timeIntervalSinceNow.)!.dropFirst())
        

    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 86400, seconds / 3600, (seconds % 3600) / 60)
    }
}

extension Date {
    var millisecondsSince1970: Int {
        Int((self.timeIntervalSince1970).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
