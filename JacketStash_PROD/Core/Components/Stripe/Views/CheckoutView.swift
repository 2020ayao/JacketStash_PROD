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



import StripePaymentSheet
import SwiftUI

class MyBackendModel: ObservableObject {
//  let backendCheckoutUrl = URL(string: "https://firestore.googleapis.com/v1/projects/jacketstash-bb91d/databases/(default)/documents/customers/6EdvcCFsdcc1iO93Tgxs3yoApUF2/checkout_sessions/6EdvcCFsdcc1iO93Tgxs3yoApUF2")! // Your backend endpoint
  @Published var paymentSheet: PaymentSheet?
  @Published var paymentResult: PaymentSheetResult?
    let publishableKey: String = "pk_test_51Lun2zA917ZeeiFb9OcWW7b0hI7mdSH6qFMaB6BpQobXdoPJchzwUK99QNYIOc3AewxzWwGVOBwaDC5eDr3Dg89D00t2h3CPrA"
    
//    var IDTxt: String
    
//    init(id: String){
//            self.IDTxt = id
//        }
    

  func preparePaymentSheet() {
    // MARK: Fetch the PaymentIntent and Customer information from the backend
      
//      Firestore.firestore().collection("customers").document(<#T##documentPath: String##String#>)
        
        
      let customerId = "cus_MpNUnzgZkxNa4H"
      let customerEphemeralKeySecret = "ek_test_YWNjdF8xTHVuMnpBOTE3WmVlaUZiLGwzbnhvcG43djBXbGVkeThjN0Qzb1B4dU84Q0hGS3I_00o2YTVwVi"
      let paymentIntentClientSecret = "pi_3M73GUA917ZeeiFb1opV9Qbw_secret_CIWNNxrUSDEhZCY4yAV6GqrUJ"
        STPAPIClient.shared.publishableKey = self.publishableKey
      // MARK: Create a PaymentSheet instance
//      var configuration = PaymentSheet.Configuration()
      
      var configuration = PaymentSheet.Configuration()
      configuration.applePay = .init(
        merchantId: "merchant.com.jacketstash",
        merchantCountryCode: "US"
      )
      
      
      configuration.merchantDisplayName = "JacketStash, Inc."
      configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
      // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
      // methods that complete payment after a delay, like SEPA Debit and Sofort.
      configuration.allowsDelayedPaymentMethods = false
      

      DispatchQueue.main.async {
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
      }
//    })
//    task.resume()
  }
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
      }
}

struct CheckoutView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @Binding var IDTxt: String
    @ObservedObject var model = MyBackendModel()

//    init(IDTxt: Binding<String>) {
//            self._IDTxt = IDTxt
//            self.model = MyBackendModel(id: IDTxt.wrappedValue)
//        }
  var body: some View {
    VStack {
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
    }.onAppear { model.preparePaymentSheet() }
  }
}


struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView().environmentObject(AuthViewModel())
    }
}
