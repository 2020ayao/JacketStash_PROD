//
//  UserCoatIDView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/6/22.
//

import SwiftUI

struct UserCoatIDView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        if let user = authViewModel.currentUser {
            VStack(alignment: .center, spacing: 20) {
                Text("Your Coat ID:")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(user.isCheckedIn ? String(user.coat_id) : "Not Checked In")
                    .font(user.isCheckedIn ? .largeTitle : .headline)
                    .fontWeight(.bold)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.blue, lineWidth: 2)
            )
            
        }
    }
}

struct UserCoatIDView_Previews: PreviewProvider {
    static var previews: some View {
        UserCoatIDView()
    }
}
