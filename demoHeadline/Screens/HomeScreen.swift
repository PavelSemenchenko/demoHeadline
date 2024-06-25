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
        NavigationStack(path: $navigationVM.currentRoute) {
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
                
                VStack(alignment: .leading, content: {
                    Text("Name")
                        .fontWeight(.bold)
                    Text("Description of the profile about Alice. who has been travelled into major state of Ukraine")
                        .multilineTextAlignment(.leading)
                        .lineLimit(5)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                })
                HStack{
                    NavigationLink(destination: Text("path")) {
                        Label("Your link name", systemImage: "link")
                            .font(.system(size: 15, weight: .bold))
                            .padding()
                        //.background(Color.gray)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .frame(alignment: .leading)
                    }
                    Spacer()
                }
                CustomDivider(color: .black, height: 2, padding: 32)
                
                GrayButton(text: "Professional panel", action: {
                    //
                }, width: UIScreen.main.bounds.width * 0.9, height: 40)
                HStack {
                    GrayButton(text: "Open profile", action: {
                        navigationVM.pushScreen(route: .editProfile)
                        print("open")
                    }, width: UIScreen.main.bounds.width * 0.45, height: 40)
                    GrayButton(text: "Share profile", action: {
                        ProfileSetupScreen()
                    }, width: UIScreen.main.bounds.width * 0.45, height: 40)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<3) { index in
                            VStack {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.yellow)
                                Text("Post \(index)")
                                    .font(.headline)
                            }
                            .frame(width: 80, height: 80)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        Button(action: {
                            print("Button tapped")
                        }) {
                            VStack {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                                Text("Add Post")
                                    .font(.headline)
                            }
                            .frame(width: 80, height: 80)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                .frame(height: 120)
                
                Spacer()
            }.onAppear {
                Task {
                    await repository.getUserInfo()
                }
            }
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .editProfile:
                    ProfileSetupScreen()
                default:
                    EmptyView()
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
