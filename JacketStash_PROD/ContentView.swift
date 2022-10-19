//
//  ContentView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/18/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showMenu = false
//    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        //        Group {
        //
        //            if viewModel.userSession == nil { // user logged in
        //                LoginView()
        //            } else {
        //                //user not logged in
        //                mainInterfaceView
        //            }
        //
        //
        //        }
        //    }
        Text("Hello")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
