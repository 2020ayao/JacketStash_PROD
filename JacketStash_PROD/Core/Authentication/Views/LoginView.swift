//
//  LoginView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/18/22.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Hello.", title2: "Welcome Back")
            
            VStack(spacing:40){
                
                CustomInputField(
                    imageName: "envelope",
                    placeholderText: "Email",
                    text: $email)
                
                CustomInputField(
                    imageName: "lock",
                    placeholderText: "Password",
                    isSecureField: true,
                    text: $password)
                
            }
            .padding(.horizontal,32)
            .padding(.top, 44)
            
            HStack {
                Spacer()
                
                NavigationLink {
                    Text("Reset password view...")
                } label: {
                    Text("Forgot Password?")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemBlue))
                        .padding(.top)
                        .padding(.trailing, 24)
                }
                
            }
            
            Button {
                viewModel.login(withEmail: email, password: password)
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(Color(.systemBlue))
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y:0)

            if viewModel.err != nil {
                HStack {
                    Image(systemName: "exclamationmark.square.fill")
                    Text(viewModel.err ?? "error")
                        
                        .foregroundColor(.red)
                    
                }
                
            }
            
            Spacer()
            
            NavigationLink  {
                RegistrationView()
                    .navigationBarHidden(true)
                    .onAppear {
                        viewModel.err = nil
                    }
            } label: {
                HStack {
                    Text("Dont have an account?")
                        .font(.footnote)
                    
                    Text("Sign Up")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 40)
            .foregroundColor(Color(.systemBlue))
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
