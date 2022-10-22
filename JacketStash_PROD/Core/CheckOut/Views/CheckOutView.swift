//
//  CheckOutView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI

struct CheckOutView: View {
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Sucess!", title2: "Let's get checked in...")
            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView()
    }
}
