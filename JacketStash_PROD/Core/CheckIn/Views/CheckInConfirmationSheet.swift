//
//  CheckInConfirmationSheet.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/16/22.
//

import SwiftUI

struct CheckInConfirmationSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var termsAccepted = false
    var body: some View {
        VStack {
            Text("Thank you for checking in!")
                .font(.title)
                .offset(y:10)
                .padding(.top, 15)
            
            if let user = viewModel.currentUser {
                let _ = print("The current coat_id is:  ")
                VStack {
                    Text("Your Coat ID:")
                        .fontWeight(.semibold)
                        .font(.title)
                    Text(String(user.coat_id))
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    Text("Show this to the checkout station.")
                        .font(.callout)
                    Toggle("I've checked in my coat", isOn: $termsAccepted)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 30)
                .padding(.bottom, 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.blue, lineWidth: 2).padding()
                )
            }
            
//            ZStack {
//                Circle()
//                    .foregroundColor(Color.blue)
//                    .frame(width: 45, height: 45)
//                    .offset(y:-235)
//                Image(systemName: "checkmark")
//                    .offset(y:-235)
//            }
            
        }
        .presentationDetents([.fraction(0.35)])
        .interactiveDismissDisabled(!termsAccepted)
        
    }

    func close() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct CheckInConfirmationSheet_Previews: PreviewProvider {
    static var previews: some View {
        CheckInConfirmationSheet()
    }
}
