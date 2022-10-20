//
//  CheckInOutViewModel.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import Foundation



enum CheckInOutViewModel: Int, CaseIterable {
    case home
    case checkIn
    case checkOut
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .checkIn: return "Check In"
        case .checkOut: return "Check Out"
        }
    }
}
