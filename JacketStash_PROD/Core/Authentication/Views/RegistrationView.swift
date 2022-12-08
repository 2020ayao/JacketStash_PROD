//
//  RegistrationView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/18/22.
//

import SwiftUI

struct RegistrationView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State var isPresentedImageView = false
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                //                NavigationLink(destination: ProfileSelectorView(), isActive: $viewModel.didAuthenticateUser, label: {})
                
                
                
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
                    //                    viewModel.register(withEmail: email,
                    //                                       password: password,
                    //                                       fullname: fullname,
                    //                                       username: username,
                    //                                       isCheckedIn: false)
                    path.append("ProfileSelectorView")
                    
                    
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y:0)
                //                .navigationDestination(for: String.self) { view in
                //                    ProfileSelectorView()
                //                }
                .navigationDestination(for: String.self) { view in
                    if view == "ProfileSelectorView" {
                        ProfileSelectorView(email: $email, username: $username, fullname: $fullname, password: $password)
                    }
                }
                if viewModel.err != nil {
                    Text(viewModel.err ?? "error")
                }
                
                
                Spacer()
                
                NavigationLink  {
                    LoginView()
                        .navigationBarHidden(true)
                        .onAppear {
                            viewModel.err = nil
                        }
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
            .onTapGesture(perform: {
                hideKeyboard()
            })
            .ignoresSafeArea()
            .navigationBarHidden(true)

        }
//        .onAppear {
//            if viewModel.tempUserSession != nil {
////                        isPresentedImageView.toggle()
//                path.append("ProfileSelectorView")
//                isPresentedImageView.toggle()
//            }
//        }

        //        .navigationDestination(isPresented: $isPresentedImageView) {
        //            ProfilePhotoSelectorView()
        //        }
        //}
    }
}
extension RegistrationView {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
