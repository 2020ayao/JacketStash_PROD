//
//  CheckInView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI
import StripeApplePay

struct CheckInView: View {
    @State var isCheckedIn = false
    
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Hey Adam!", title2: "Let's get checked in...")
            
            Spacer()
            
            CheckInOutButton(isDetectingLongPress: false, isCheckedIn: false, title: "Check In")
        }
        .ignoresSafeArea()
    }
}


struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
    }
}



