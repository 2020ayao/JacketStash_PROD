//
//  CheckInView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI
import StripePaymentSheet

struct CheckInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = CheckedInViewModel()
    @ObservedObject var vModel = CheckInNotifViewModel()
    
    @State var checkedIn = false
    @State var checkedOut = false
    
    @State var clicked = false

    let IDTxt: String
    @ObservedObject var model: MyBackendModel
    @EnvironmentObject var checkoutViewModel: CheckoutViewModel
    
    
    init(IDTxt: String) {
        self.IDTxt = IDTxt
        self.model = MyBackendModel(id: self.IDTxt)
    }
    
    
    var body: some View {
        if let user = authViewModel.currentUser {
            ZStack(alignment: .bottom){
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.feed) { feed in
                            CheckInNotifView(feed: feed, viewModel: vModel)
                                .padding()
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchFeed()
                }
                
                if let result = model.paymentResult {
                    switch result {
                    case .completed:
                        Text("Payment completed").onAppear {
                            checkedIn.toggle()
                            authViewModel.checkIn()
                            clicked.toggle()
                        }
                    case .failed(let error):
                        Text("Error with: \(error.localizedDescription)")
                            .onAppear {
                                clicked.toggle()
                            }
                            
                    case .canceled:
                        Text("Payment canceled")
                            .onAppear {
                                model.preparePaymentSheet()
                                clicked.toggle()
                            }
                    }
                }
                
                if user.isCheckedIn {
                    CheckInOutButton(checkIn: $checkedIn, checkOut: $checkedOut, title: "Check Out")
                        .popover(isPresented: $checkedIn, content: CheckInConfirmationSheet.init)

                        .offset(y:100)
                        .onAppear {
                            print("checkedIn: \(checkedIn)")
                        }
                }
                else {
                    //                    paymentSheet
                    if clicked == false {
                        ZStack {
                            Circle()
                                .fill(Color(.systemBlue))
                                .frame(width: 100, height: 100)
                            Button(action: {
                                checkoutViewModel.initiatePayment(withUid: IDTxt)
                                model.preparePaymentSheet()
                                clicked.toggle()
                            }, label: {
                                Text("Check In")
                            })
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.headline)
                        }.offset(y:-20)
                            .popover(isPresented: $checkedOut, content: CheckOutConfirmationView.init)
                    }
                    
                    else {
                        paymentSheet
                            .popover(isPresented: $checkedOut, content: CheckOutConfirmationView.init)
                    }
                    
                        
                }
                
            }
            
            .onAppear {
                checkoutViewModel.initiatePayment(withUid: IDTxt)
                model.preparePaymentSheet()
            }
            .onChange(of: checkedOut) { newValue in
                checkoutViewModel.initiatePayment(withUid: IDTxt)
                model.preparePaymentSheet()
            }
        }
        else {
            LaunchScreen()
        }
    }
    func toggleStatus() {
        checkedIn.toggle()
    }
}

extension CheckInView {
    
    
    var paymentSheet : some View {
        VStack {
            if let paymentSheet = model.paymentSheet {
                PaymentSheet.PaymentButton(
                    paymentSheet: paymentSheet,
                    onCompletion: model.onPaymentCompletion
                ) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemBlue))
                            .frame(width: 100, height: 100)
                        
                        Text("Confirm")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.headline)
                    }.offset(y:-20)
                    
                }
            } else {
                Text("Loading…")
            }
        }
//        }.onAppear {
//            checkoutViewModel.initiatePayment(withUid: IDTxt)
//            model.preparePaymentSheet()
//        }
    }
    
    var checkOutConfirmation : some View {
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
                    if let user = authViewModel.currentUser {
//                        let _ = print("The current coat_id is:  ")
                        VStack {
//                            Text("Show this to the checkout station")
                            Text("Coat ID:")
                                .fontWeight(.semibold)
                                .font(.headline)
                                .offset(y:20)
                            Text(String(user.coat_id))
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                }
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.35)])
    }
    
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
                if let coat_id = authViewModel.currentUser?.coat_id {
                    Text("Your coat ID for the night is # \(coat_id)")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .offset(y:20)
                }
            }
            Spacer()
        }
        
        
    }
    .presentationDetents([.fraction(0.35)])
    }
}



