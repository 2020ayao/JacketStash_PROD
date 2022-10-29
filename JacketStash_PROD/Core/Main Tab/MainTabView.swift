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
        CheckInView()
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

