//
//  UserStatsView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI

struct UserStatsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        HStack(spacing:24){
            HStack(spacing:4) {
                Text("807")
                    .font(.subheadline)
                    .bold()
                
                
                Text("Following")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing:4) {
                Text("6.9M")
                    .font(.subheadline)
                    .bold()
                
                
                Text("Following")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct UserStatsView_Previews: PreviewProvider {
    static var previews: some View {
        UserStatsView()
    }
}

