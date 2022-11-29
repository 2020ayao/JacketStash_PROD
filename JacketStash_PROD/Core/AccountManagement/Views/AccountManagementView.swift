//
//  AccountManagementView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/28/22.
//

import SwiftUI
import Kingfisher

struct AccountManagementView: View {
    @EnvironmentObject var viewModel:
    AuthViewModel
    @State private var confirmationShown = false
    
    @State private var password: String = ""
    
    @State private var showAlert = false
    
    var body: some View {
        if let user = viewModel.currentUser {
            
            VStack(alignment: .center, spacing: 10) {
                Text("Delete Account")
                    .fontWeight(.bold)
                
                                KFImage(URL(string: user.profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 75, height: 75)
                
//                Circle()
//                    .frame(width: 48, height: 48)
                
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    VStack(alignment: .leading) {
                        Text("Deleting your account is permanant")
                            .fontWeight(.bold)
                        Text("Your profile, username, and activity will be permanantly deleted.")
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                Divider()
                
                Button(role: .destructive) {
                    showAlert = true
                } label: {
                    Text("Delete account")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                
            }
            .alert("Delete Account", isPresented: $showAlert, actions: {
                SecureField("Password", text: $password)
                
                
                Button("Delete Account",role: .destructive, action: {
                    viewModel.deleteAccount(withEmail: user.email, withPassword: password)
                })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Please enter your password to confirm.")
            })
        }
        
        
        
    }
    
}
struct AccountManagementView_Previews: PreviewProvider {
    static var previews: some View {
        AccountManagementView().environmentObject(AuthViewModel())
    }
}
