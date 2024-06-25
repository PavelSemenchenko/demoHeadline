//
//  TabBar.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 18.06.2024.
//

import SwiftUI

enum TabBarId: Int, Hashable {
    case home = 0
    case profile = 1
}

struct TabBar: View {
    @EnvironmentObject private var navigationVM: NavigationRouter
    @State var currentTab = TabBarId.home
    
    var body: some View {
        TabView(selection: $currentTab){
            HomeScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(TabBarId.home)
            ProfileSetupScreen()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(TabBarId.profile)
        }.navigationBarBackButtonHidden(true)
            .environmentObject(navigationVM)
            
    }
}

#Preview {
    TabBar().environmentObject(NavigationRouter())
        .environmentObject(AuthVM())
        .environmentObject(UserRepository())
}
