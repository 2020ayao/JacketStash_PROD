//
//  EditProfileView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/14/22.
//

import SwiftUI

struct EditProfileView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var username = ""
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        if let user = viewModel.currentUser {
            VStack {
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 150, height: 150)
                    .padding(.top, 80)
                VStack(spacing: 10) {
                    CustomTextBox(placeholderText: "Email", isSecureField: false, text: .constant(user.email))
                    CustomTextBox(placeholderText: "Username", text: .constant(user.username))
                    CustomTextBox(placeholderText: "Full Name", text: .constant(user.fullname))
                }
                
                
                .padding(.horizontal,15)
                .padding(.top, 44)
                Spacer()
                
                Button {
                    //                viewModel.login(withEmail: email, password: password)
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y:0)
            }
        }
    }
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView()
//
//    }
//}
