//
//  CheckOutConfirmationView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/16/22.
//

import SwiftUI

struct CheckOutConfirmationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var termsAccepted = false

    var body: some View {
        VStack {
            Text("Thank you for using JacketStash!")
                .font(.title2)
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
                    Toggle("I've received my coat", isOn: $termsAccepted)
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
            
        }
        .presentationDetents([.fraction(0.35)])
        .interactiveDismissDisabled(!termsAccepted)
        
    }

    func close() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct CheckOutConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutConfirmationView()
    }
}
