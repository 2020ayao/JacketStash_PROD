//
//  CheckoutView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/18/22.
//

import StripePaymentSheet
import SwiftUI
import Firebase
import Stripe
import StripeApplePay

import StripePaymentSheet
import SwiftUI

class MyBackendModel: ObservableObject {
//  let backendCheckoutUrl = URL(string: "https://firestore.googleapis.com/v1/projects/jacketstash-bb91d/databases/(default)/documents/customers/6EdvcCFsdcc1iO93Tgxs3yoApUF2/checkout_sessions/6EdvcCFsdcc1iO93Tgxs3yoApUF2")! // Your backend endpoint
  @Published var paymentSheet: PaymentSheet?
  @Published var paymentResult: PaymentSheetResult?
    //----------------TESTING PK------------
//    let publishableKey: String = "pk_test_51Lun2zA917ZeeiFb9OcWW7b0hI7mdSH6qFMaB6BpQobXdoPJchzwUK99QNYIOc3AewxzWwGVOBwaDC5eDr3Dg89D00t2h3CPrA"
    
    //----------------LIVE PK---------------
    let publishableKey: String = "pk_live_51Lun2zA917ZeeiFbCECGBVpOeyNl0VVqzvwCnjpksQZuIdrhqiyfTEJZLW0fHSsClrdVG77KggHAGXGmXxxZDYFA00aTTxVh68"
    
    let IDTxt: String
    
    var customerId:String? = nil
    var customerEphemeralKeySecret:String? = nil
    var paymentIntentClientSecret:String? = nil
    
    init(id: String){
            self.IDTxt = id
        }

  func preparePaymentSheet() {
    // MARK: Fetch the PaymentIntent and Customer information from the backend
      
      let listener = Firestore.firestore().collection("customers").document(IDTxt).collection("checkout_sessions").addSnapshotListener { querySnapshot, error in
          guard let snapshot = querySnapshot else {
              print("Error fetching snapshots: \(error!)")
              return
          }
          snapshot.documentChanges.forEach { diff in
              if (diff.type == .modified) {
                  print("New data: \(diff.document.data())")
                  
                  //                  let customerId = "cus_MpNUnzgZkxNa4H"
                  //                  let customerEphemeralKeySecret = "ek_test_YWNjdF8xTHVuMnpBOTE3WmVlaUZiLGwzbnhvcG43djBXbGVkeThjN0Qzb1B4dU84Q0hGS3I_00o2YTVwVi"
                  //                  let paymentIntentClientSecret = "pi_3M73GUA917ZeeiFb1opV9Qbw_secret_CIWNNxrUSDEhZCY4yAV6GqrUJ"
                  
                  //                  print("DEBUG CUSTOMER: \(diff.document.data()["customer"])")
                  
                  
                  self.customerId = diff.document.data()["customer"] as? String
                  self.customerEphemeralKeySecret = diff.document.data()["ephemeralKeySecret"] as? String
                  self.paymentIntentClientSecret = diff.document.data()["paymentIntentClientSecret"] as? String
                  
                  print("DEBUG: \(self.customerId)")
                  print("DEBUG: \(self.customerEphemeralKeySecret)")
                  print("DEBUG: \(self.paymentIntentClientSecret)")
                  
                  
                  //                  print("DEBUG: \(customerId)")
                  //                  print("DEBUG: \(customerEphemeralKeySecret)")
                  //                  print("DEBUG: \(paymentIntentClientSecret)")
                  
                  
                  STPAPIClient.shared.publishableKey = self.publishableKey
                  // MARK: Create a PaymentSheet instance
                  //      var configuration = PaymentSheet.Configuration()
                  
                  var configuration = PaymentSheet.Configuration()
                  configuration.applePay = .init(
                    merchantId: "merchant.jacketstash",
                    merchantCountryCode: "US"
                  )
                  
                  if let customerId = self.customerId{
                      
                      if let customerEphemeralKeySecret = self.customerEphemeralKeySecret {
                          configuration.merchantDisplayName = "JacketStash, Inc."
                          configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
                          // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
                          // methods that complete payment after a delay, like SEPA Debit and Sofort.
                          configuration.allowsDelayedPaymentMethods = true
                      }
                  }
                  
                  if let paymentIntentClientSecret = self.paymentIntentClientSecret {
                      DispatchQueue.main.async {
                          self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
                      }
                  }
              }
              
//              if (diff.type == .modified) {
//                  print("modified data: \(diff.document.data())")
//
//              }
              //    })
              //    task.resume()
          }
          
          
      }
//      listener.remove()

  }
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
      }
}

struct CheckoutView: View {
    let IDTxt: String
    @ObservedObject var model: MyBackendModel
    @EnvironmentObject var checkoutViewModel: CheckoutViewModel
    

    init(IDTxt: String) {
        self.IDTxt = IDTxt
        self.model = MyBackendModel(id: self.IDTxt)
        }
  var body: some View {
    VStack {
        Button {
            checkoutViewModel.initiatePayment(withUid: IDTxt)
            model.preparePaymentSheet()
        } label: {
            Text("I want to check in")
        }

      if let paymentSheet = model.paymentSheet {
        PaymentSheet.PaymentButton(
          paymentSheet: paymentSheet,
          onCompletion: model.onPaymentCompletion
        ) {
          Text("Buy")
        }
      } else {
        Text("Loading…")
      }
      if let result = model.paymentResult {
        switch result {
        case .completed:
          Text("Payment complete")
        case .failed(let error):
          Text("Payment failed: \(error.localizedDescription)")
        case .canceled:
          Text("Payment canceled.")
        }
      }
    }
//            .onAppear { model.preparePaymentSheet() }
  }
}


//struct CheckoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckoutView().environmentObject(AuthViewModel())
//    }
//}
