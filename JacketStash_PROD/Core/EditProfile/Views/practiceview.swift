//
//  practiceview.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/28/22.
//

import SwiftUI

struct practiceview: View {
    @State private var fullname = ""
    @State private var username = ""
    @State private var disabled = true

    var body: some View {
        VStack(spacing: 10) {
//            Text("user.email")
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
////                        .padding()
////                            .overlay(
////                                RoundedRectangle(cornerRadius: 5)
////                                    .stroke(.gray, lineWidth: 1)
            ///
//                            )
            CustomTextBox(placeholderText: "Email", isSecureField: false, text: .constant("adamyao3240@gmail.com"), disabled: $disabled).padding(.bottom, 20).disabled(true).opacity(0.5)
            CustomTextBox(placeholderText: "Username", text: $username, disabled: $disabled)
            CustomTextBox(placeholderText: "Full Name", text: $fullname, disabled: $disabled)
        }
    }
}

struct practiceview_Previews: PreviewProvider {
    static var previews: some View {
        practiceview()
    }
}
