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
            HomeView()
                .onTapGesture {
                    self.selectedIndex = 0
                }
                .tabItem {
                    Image(systemName: "house")
                }.tag(0)
            
            CheckInView()
                .onTapGesture {
                    self.selectedIndex = 1
                }
                .tabItem {
                    Image(systemName: "lock")
                }.tag(1)
            
            CheckOutView()
                .onTapGesture {
                    self.selectedIndex = 2
                }
                .tabItem {
                    Image(systemName: "lock.open")
                }.tag(2)
            
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
