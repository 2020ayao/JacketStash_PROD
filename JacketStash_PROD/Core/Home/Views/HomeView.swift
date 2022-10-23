//
//  HomeView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        
        VStack {
            Text("Home View")
            
            Button {
                authViewModel.signOut()
            } label: {
                Text("Sign Out")
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
