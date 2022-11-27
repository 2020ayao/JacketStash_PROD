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
    
    @State var showForgotPassword = false
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
            
            //--------------RESET PASSWORD------------------
            
            HStack {
                Spacer()
                
                Button {
                    showForgotPassword.toggle()
                } label: {
                    Text("Forgot Password?")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemBlue))
                        .padding(.top)
                        .padding(.trailing, 24)
                }.sheet(isPresented: $showForgotPassword) {
                    ForgotPasswordView()
                }

            }
            //------------------------------------
            
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
                Text(viewModel.err ?? "error").padding()
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
                    Text("Don't have an account?")
                        .font(.footnote)
                    
                    Text("Sign Up")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 40)
            .foregroundColor(Color(.systemBlue))
        }
        .onTapGesture {
            hideKeyboard()
            
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
        
}

extension LoginView {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
