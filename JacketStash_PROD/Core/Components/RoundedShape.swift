//
//  RoundedShape.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import Foundation

import SwiftUI

struct RoundedShape: Shape {
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 80, height: 80))
        
        return Path(path.cgPath)
    }
}
