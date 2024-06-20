//
//  demoHeadlineApp.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI
import Firebase
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}


@main
struct demoHeadlineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var navigationVM = NavigationRouter()
    @StateObject var authVM = AuthVM()
    @StateObject private var userRepository = UserRepository()
    
    var body: some Scene {
        WindowGroup {
            //NavigationStack(path: $navigationVM.currentRoute) {
                if authVM.isAuthenticated {
                    TabBar(currentTab: .home)
                        .environmentObject(navigationVM)
                        .environmentObject(authVM)
                } else {
                    NavigationStack(path: $navigationVM.currentRoute) {
                    SplashScreen()
                        .navigationDestination(for: NavigationRoute.self) { route in
                            switch route {
                            case .splash:
                                SplashScreen()
                                    .environmentObject(navigationVM)
                            case .home:
                                HomeScreen()
                                    .environmentObject(navigationVM)
                                    .environmentObject(authVM)
                                    .environmentObject(userRepository)
                            case .signUp:
                                SignUpScreen()
                                    .environmentObject(navigationVM)
                            case .signIn:
                                SignInScreen()
                                    .environmentObject(navigationVM)
                                    .environmentObject(authVM)
                            case .tabBar:
                                TabBar()
                                    .environmentObject(navigationVM)
                                    .environmentObject(authVM)
                                    .environmentObject(userRepository)
                            }
                        }
                }.navigationBarBackButtonHidden(true)
                    .environmentObject(navigationVM)
                        .environmentObject(authVM)
                        .environmentObject(userRepository)
            }//.environmentObject(navigationVM)
                //.environmentObject(authVM)
        }
    }
}
