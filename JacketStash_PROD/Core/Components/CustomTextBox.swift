//
//  CustomTextBox.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/15/22.
//

import SwiftUI

struct CustomTextBox: View {
    let placeholderText: String
    var isSecureField: Bool? = false
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(placeholderText)
                .font(.caption)
                .padding(.top, 5)
                .padding(.leading, 5)
            
            
            if isSecureField ?? false{
                SecureField(placeholderText, text: $text)
                    .padding(.leading, 10)
                    .padding(.bottom, 5)

            } else {
                TextField(placeholderText, text: $text)
                    .padding(.leading, 10)
                    .padding(.bottom, 5)

            }
        }
        .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
        
    }
    
}

struct CustomTextBox_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextBox(placeholderText: "Email", isSecureField: false, text: .constant("placeholder"))
    }
}
