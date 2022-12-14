//
//  SideMenuViewModel.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import Foundation


enum SideMenuViewModel: Int, CaseIterable {
    case profile
    case accountManagement
    case logout
    
    var title: String {
        switch self {
        case .accountManagement: return "Account Management"
        case .profile: return "Edit Profile"
        case .logout: return "Logout"
        }
    }
    
    var imageName: String {
        switch self {
        case .accountManagement: return "lock.shield"
        case .profile: return "person"
        case .logout: return "arrow.left.square"
        }
    }
}
