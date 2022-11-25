//
//  CheckOutView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI

struct CheckOutView: View {
    @State var isCheckedIn = true
    var body: some View {
            Text("Hello World")
        }
    
    struct CheckOutView_Previews: PreviewProvider {
        static var previews: some View {
            CheckOutView()
                .environmentObject(AuthViewModel())
        }
    }
}

