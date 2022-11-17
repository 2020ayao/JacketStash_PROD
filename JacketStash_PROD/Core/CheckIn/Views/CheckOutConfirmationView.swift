//
//  CheckOutConfirmationView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/16/22.
//

import SwiftUI

struct CheckOutConfirmationView: View {
    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var viewModel: AuthViewModel

    @State private var termsAccepted = false

    var body: some View {
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
                
                
                VStack(spacing: 12){
                    Text("Thank you for using JacketStash!")
                        .fontWeight(.semibold)
                        .font(.title2)
                    Text("Show this to the checkout station.")
                        .font(.title3)
//                    if let user = viewModel.currentUser {
                        //                        let _ = print("The current coat_id is:  ")
                        VStack {
                            //                            Text("Show this to the checkout station")
                            Text("Coat ID:")
                                .fontWeight(.semibold)
                                .font(.headline)
//                            Text(String(user.coat_id))
                            Text("2")
                                .font(.title)
                                .fontWeight(.bold)
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(.white)
                                    .frame(height: 85)
                                Toggle("I've received my coat", isOn: $termsAccepted)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 20)
                            }
                        }
//                    }
                }
                .offset(y:30)
                
                
                
                Spacer()
                
            }
            
            
            
            
        }
        .presentationDetents([.fraction(0.45)])
        .interactiveDismissDisabled(!termsAccepted)
        Spacer()
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
