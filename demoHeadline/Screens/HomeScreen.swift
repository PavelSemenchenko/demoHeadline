//
//  HomeScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var authVM : AuthVM
    @EnvironmentObject private var navigationVM : NavigationRouter
    @EnvironmentObject private var repository: UserRepository
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if let userID = authVM.userID {
                    Text("User ID: \(userID)")
                        .foregroundStyle(.orange)
                } else {
                    Text("No user ID available")
                        .foregroundStyle(.red)
                }
                HStack {
                    Text("Hello, \(repository.name)")
                        .fontWeight(.bold)
                        .padding()
                    Text("+\(repository.lastName)")
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        authVM.signOut(navigationVM: navigationVM)
                    }) {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .padding()
                }
                CustomDivider(color: .black, height: 2, padding: 32)
                
                
                NavigationLink(destination: ProfileSetupScreen()) {
                    Text("Edit profile")
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
            }.onAppear {
                Task {
                    await repository.getUserInfo()
                }
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
