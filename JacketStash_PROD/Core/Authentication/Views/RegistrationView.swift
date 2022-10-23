//
//  RegistrationView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/18/22.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    @State var isPresentedImageView = false
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    
    var body: some View {
            
            VStack {
                AuthHeaderView(title1: "Get Started.", title2: "Create your account")
                
                VStack(spacing:40){
                    
                    CustomInputField(
                        imageName: "envelope",
                        placeholderText: "Email",
                        text: $email)
                    
                    CustomInputField(
                        imageName: "person",
                        placeholderText: "Username",
                        text: $username)
                    
                    CustomInputField(
                        imageName: "person",
                        placeholderText: "Full Name",
                        text: $fullname)
                    
                    CustomInputField(
                        imageName: "lock",
                        placeholderText: "Password",
                        isSecureField: true,
                        text: $password)
                    
                }
                .padding(32)
                
                
                Button {
                    viewModel.register(withEmail: email,
                                       password: password,
                                       fullname: fullname,
                                       username: username,
                                       isCheckedIn: false)
                    isPresentedImageView.toggle()
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y:0)
                
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.footnote)
                        
                        Text("Sign In")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 40)
                .foregroundColor(Color(.systemBlue))
                
            }
            .ignoresSafeArea()
        }
//        .navigationDestination(isPresented: $isPresentedImageView) {
//            ProfilePhotoSelectorView()
//        }
    //}
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
