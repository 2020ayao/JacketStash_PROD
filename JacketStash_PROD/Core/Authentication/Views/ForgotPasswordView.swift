//
//  ForgotPasswordView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/25/22.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Reset Password")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(.top, 30)
                    .padding()
                
                Spacer()
                
            }
            
            CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                .padding()
                
            Button {
                authViewModel.sendResetPasswordEmail(withEmail: email)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Reset Password")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(Color(.systemBlue))
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y:0)
            
            Spacer()
        }

    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
