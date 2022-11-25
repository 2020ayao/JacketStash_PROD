//
//  LaunchScreen.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/14/22.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var visible = true
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Spacer()
//            Text("JacketStash")
            Image("LaunchScreen")
                .resizable()
                
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
//                .onAppear(perform: pulsateText)
                .shadow(radius: 5)
            Spacer()
//            Button {
//                authViewModel.signOut()
//            } label: {
//                Text("Sign Out")
//            }
            Text("Powered by JacketStash")
                .padding()
            
        }
    }
    private func pulsateText() {
        withAnimation(Animation.easeInOut.repeatForever(autoreverses: true)) {
            visible.toggle()
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
