//
//  HomeScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI
 
struct HomeScreen: View {
    @State var name : String = "User"
    @EnvironmentObject private var authVM : AuthVM
    @EnvironmentObject private var navigationVM : NavigationRouter
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if let userID = authVM.userID {
                                Text("User ID: \(userID)")
                                    .padding()
                            } else {
                                Text("No user ID available")
                                    .padding()
                            }
                    
                    Button("Sign Out") {
                        authVM.signOut(navigationVM: navigationVM)
                        
                    }
                
                Spacer()
                
                Text("Hello, \(name)")
                    .fontWeight(.bold)
                    .padding()
                NavigationLink(destination: SignInScreen()) {
                    Text("Sign In")
                        .foregroundColor(.blue)
                        .padding()
                }
                NavigationLink(destination: SignUpScreen()) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    // Создаем временные данные для предварительного просмотра
    let authVM = AuthVM()
    let navigationVM = NavigationRouter()
    
    return HomeScreen()
        .environmentObject(authVM)
        .environmentObject(navigationVM)
}
