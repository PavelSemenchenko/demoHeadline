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
    
    var body: some Scene {
        WindowGroup {
            //NavigationStack(path: $navigationVM.currentRoute) {
                if authVM.isAuthenticated {
                    HomeScreen()
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
                            case .signUp:
                                SignUpScreen()
                                    .environmentObject(navigationVM)
                            case .signIn:
                                SignInScreen()
                                    .environmentObject(navigationVM)
                                    .environmentObject(authVM)
                            }
                        }
                }.environmentObject(navigationVM)
                        .environmentObject(authVM)
            }//.environmentObject(navigationVM)
                //.environmentObject(authVM)
        }
    }
}
