//
//  SideMenuView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI
import Firebase
import Kingfisher



struct SideMenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        
        if let user = authViewModel.currentUser {
//            let _ = print(user.fullname)
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading){
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 48, height: 48)
                    
                    
                    VStack (alignment: .leading, spacing:4) {
                        Text(user.fullname)
                            .font(.headline)
                        
                        Text ("@\(user.username)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                }
                
                .padding(.leading)
                
                UserCoatIDView()
                    .padding(.leading)
                
                ForEach(SideMenuViewModel.allCases, id: \.rawValue) { viewModel in
                    if viewModel == .profile {
                        NavigationLink {
                            EditProfileView()
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    } else if viewModel == .logout {
                        Button {
                            authViewModel.signOut()
                        } label:{
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    } else {
                        SideMenuOptionRowView(viewModel: viewModel)
                    }
                }
                Spacer()
            }
        }
        
    }
}

//struct SideMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        SideMenuView()
//    }
//}


