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
                            ZStack {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .padding()
                                    .padding(.top, 30)
                                    .foregroundColor(Color.mint)
                                //.frame(width: 200, height: 150)
                                VStack {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(Color.white)
                                            .frame(width: 50, height: 50)
                                        Circle()
                                            .foregroundColor(Color.mint)
                                            .frame(width: 45, height: 45)
                                        Image(systemName: "checkmark")
                                    }
                                    .offset(y:25)
                                    
                                    VStack(spacing:10) {
                                        Text("Thank you for using JacketStash!")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 20))
                                            .offset(y:20)
                                        Text("Coat ID: #\(String(user.coat_id))")
                                            .fontWeight(.semibold)
                                            .font(.headline)
                                            .offset(y:20)
                                    }
                                    
                                    
                                    Spacer()
                                }
                                
                                
                            }
                            .presentationDetents([.fraction(0.35)])
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
}

struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView()
            .environmentObject(AuthViewModel())
    }
}

