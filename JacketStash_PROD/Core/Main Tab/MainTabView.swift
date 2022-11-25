//
//  MainTabView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI

import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    //@State var checkedIn = false
    var body: some View {
        //        if let user = authViewModel.currentUser {
        if authViewModel.userSession != nil {
            CheckInView(IDTxt: authViewModel.userSession!.uid)
        }
//        else {
//            LoginView()
//        }
    }
    
    //                        Button {
    //                            authViewModel.signOut()
    //                        } label: {
    //                            Text("Sign Out")
    //                        }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

