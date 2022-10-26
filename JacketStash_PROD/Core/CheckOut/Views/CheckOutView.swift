//
//  CheckOutView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI

struct CheckOutView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var isCheckedIn = true
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack {
                if isCheckedIn {
                    AuthHeaderView(title1: "Sucess!", title2: "Check out when you're ready...")
                    Spacer()
                    
                    Button {
                        isCheckedIn.toggle()
                    } label: {
                        Text("Press to toggle")
                    }
                    
                    Button {
                        authViewModel.signOut()
                    } label: {
                        Text("Sign Out")
                    }
                    
                    
                    CheckInOutButton(checkingIn: false, title: "Check Out")
                    
                        .sheet(isPresented: $authViewModel.isCheckedOut) { // 3
                            
                            
                        }
                }
                else {
                    AuthHeaderView(title1: "Oops...", title2: "looks like nothing has been checked in")
                    Button {
                        isCheckedIn.toggle()
                    } label: {
                        Text("Press to toggle")
                    }
                    Spacer()
                }
                
                
                
                
            }
            .ignoresSafeArea()
        }
    }
    
    struct CheckOutView_Previews: PreviewProvider {
        static var previews: some View {
            CheckOutView()
                .environmentObject(AuthViewModel())
        }
    }
}

