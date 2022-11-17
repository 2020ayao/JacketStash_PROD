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
        ZStack(alignment: .top){
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 200, height: 150)
                .foregroundColor(Color(.systemBlue))
                .shadow(radius: 10)
            
            if let user = authViewModel.currentUser {
                VStack(spacing: 20) {
                    Text("Your Coat ID:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Text(user.isCheckedIn ? String(user.coat_id) : "N/A")
                        .font(user.isCheckedIn ? .largeTitle : .headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        
                }
                .padding()
            }
        }
        
    }
}

//struct UserCoatIDView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserCoatIDView()
//    }
//}
