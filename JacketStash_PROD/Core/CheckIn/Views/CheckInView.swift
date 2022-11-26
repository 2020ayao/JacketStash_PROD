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
    
    @State var isPressed = false

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
                        Text("").onAppear {
                            checkedIn.toggle()
                            authViewModel.checkIn()
                            clicked.toggle()
                        }
                    case .failed(let error):
                        Text("")
                            .onAppear {
                                clicked.toggle()
                            }
                            
                    case .canceled:
                        Text("")
                            .onAppear {
                                model.preparePaymentSheet()
                                clicked.toggle()
                            }
                    }
                }
                
                if user.isCheckedIn {
                    CheckInOutButton(checkIn: $checkedIn, checkOut: $checkedOut)
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
                                VStack {
                                    Text("Check")
                                        .fontWeight(.bold)
                                        .font(.title3)
                                    Text("In")
                                        .fontWeight(.bold)
                                        .font(.title3)
                                }
                            })
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.headline)
                            
                            
                        }
                        .offset(y:-20)
                        .popover(isPresented: $checkedOut, content: CheckOutConfirmationView.init)
//                        .scaleEffect(isPressed ? 0.5 : 1)
//                        .animation(.easeIn(duration: 1), value: isPressed)
//                        .pressEvents {
//                            withAnimation(.easeIn(duration: 1.0)) {
//                                isPressed = true
//                            }
//                        } onRelease: {
//                            withAnimation {
//                                isPressed = false
//                            }
//                        }
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
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.blue)
                        .frame(width: 150, height: 50)
                        .overlay(
                            Text("Confirm")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        
                    
                }.offset(y:-60)
            } else {
                ProgressView()
            }
        }
//        }.onAppear {
//            checkoutViewModel.initiatePayment(withUid: IDTxt)
//            model.preparePaymentSheet()
//        }
    }
}



