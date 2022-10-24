//
//  CheckInView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI

struct CheckInView: View {
    //    var cb: CheckInOutButton
//    @State private var isPressed = false
    @State var showingPopup = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack {
//                guard let user = authViewModel.currentUser else {return}
                
                let _ = print(user.fullname)
                AuthHeaderView(title1: "Hey \(user.fullname)!", title2: "Let's get started...")
                
                Spacer()
            
                CheckInOutButton(checkingIn: true, title: "Check In")
                    .sheet(isPresented: $authViewModel.isCheckedIn) { // 3
                        checkInConfirmation
                    }
            }
            .ignoresSafeArea()
        }
    }
}


struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
            .environmentObject(AuthViewModel())
    }
}

extension CheckInView {
    
    var checkInConfirmation : some View {
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
                Text("Thank you for checking in! ")
                    .fontWeight(.semibold)
                    .font(.title)
                    .offset(y:20)
                Text("Your coat ID for the night is # \( String(authViewModel.currentUser!.coat_id) ?? "-1" )")
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
