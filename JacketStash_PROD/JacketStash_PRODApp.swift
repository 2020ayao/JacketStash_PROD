//
//  JacketStash_PRODApp.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/18/22.
//

import SwiftUI
import Firebase

@main
struct JacketStash_PRODApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var vModel = CheckedInViewModel()
    @StateObject var paymentModel = CheckoutViewModel()
//    @StateObject var backendModel = MyBackendModel()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
//                CheckoutView()
//                .environmentObject(viewModel)
//                .environmentObject(backendModel)
                
            }
            .environmentObject(viewModel)
            .environmentObject(vModel)
            .environmentObject(paymentModel)
            
        }
    }
}
