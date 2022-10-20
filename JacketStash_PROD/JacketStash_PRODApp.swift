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
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(viewModel)
        }
    }
}
