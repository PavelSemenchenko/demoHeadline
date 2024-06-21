//
//  HomeScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI

struct HomeScreen: View {
    //@State var name : String = "User"
    @EnvironmentObject private var authVM : AuthVM
    @EnvironmentObject private var navigationVM : NavigationRouter
    @EnvironmentObject private var repository: UserRepository
    
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
                HStack {
                    Text("Hello, \(repository.name)")
                        .fontWeight(.bold)
                        .padding()
                    /*
                     .onAppear {
                     //if authVM.name == "..." {
                     Task {
                     //await authVM.getUserInfo()
                     print("Current User name from repo \(repository.name)")
                     print("Current User last from repo \(repository.lastName)")
                     }
                     //}
                     }*/
                    Text("+\(repository.lastName)")
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    Button("Sign Out") {
                        authVM.signOut(navigationVM: navigationVM)
                        
                    }.padding()
                }
                CustomDivider(color: .black, height: 2, padding: 32)
                
                
                NavigationLink(destination: ProfileSetupScreen()) {
                    Text("Edit profile")
                        .foregroundColor(.blue)
                        .padding()
                }
                /*
                 NavigationLink(destination: SignInScreen()) {
                 Text("Sign In")
                 .foregroundColor(.blue)
                 .padding()
                 }
                 NavigationLink(destination: SignUpScreen()) {
                 Text("Sign Up")
                 .foregroundColor(.blue)
                 .padding()
                 }*/
                Spacer()
            }.onAppear {
                Task {
                    await repository.getUserInfo()
                }
                //print("name is \(repository.name)")
                //print("last name is \(repository.lastName)")
            }
        }
    }
}
struct CustomDivider: View {
    var color: Color = .black
    var height: CGFloat = 1
    var padding: CGFloat = 16
    
    var body: some View {
        Divider()
            .background(color)
            .frame(height: height)
        //.padding(.horizontal, padding)
        //.edgesIgnoringSafeArea(.horizontal)
    }
}

#Preview {
    // Создаем временные данные для предварительного просмотра
    let authVM = AuthVM()
    let navigationVM = NavigationRouter()
    let repo = UserRepository()
    
    return HomeScreen()
        .environmentObject(authVM)
        .environmentObject(navigationVM)
        .environmentObject(repo)
}
