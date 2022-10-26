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
    
    var body: some View {
    
        
        TabView(selection: $selectedIndex) {
            CheckInView()
                .onTapGesture {
                    self.selectedIndex = 0
                }
                .tabItem {
                    Image(systemName: "lock")
                }.tag(0)
            
            CheckOutView()
                .onTapGesture {
                    self.selectedIndex = 1
                }
                .tabItem {
                    Image(systemName: "lock.open")
                }.tag(1)
            
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
