//
//  ProfileSetupScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 10.06.2024.
//

import SwiftUI

struct ProfileSetupScreen: View {
    @EnvironmentObject private var navigationVM: NavigationRouter
    @EnvironmentObject private var repository: UserRepository
    @EnvironmentObject private var authVM: AuthVM
    @State private var name = ""
    @State private var lastName = ""
    
    var body: some View {
        VStack{
            TextField("Enter your first name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)
                .padding()
            TextField("Enter your last name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)
                .padding()
            
            Button("Save Profile") {
                guard !name.isEmpty, !lastName.isEmpty else { return }
                Task {
                    do {
                        var service = UserRepository()
                        service.navigationVM = navigationVM
                        try await service.addLastName(name: name, lastName: lastName)
                        
                        // Вызов метода для обновления имени пользователя
                        try await authVM.updateName(name: name)
                        
                        navigationVM.pushHome()
                    } catch {
                        // Обработка ошибок
                    }
                }
            }.padding()
            /*
            Button("Save Profile") {
                guard !name.isEmpty, !lastName.isEmpty else { return }
                Task {
                    do {
                        var service = UserRepository()
                        service.navigationVM = navigationVM
                        try await service.addLastName(name: name, lastName: lastName)
                        navigationVM.pushHome()
                    } catch {
                        
                    }
                }
                navigationVM.pushHome()
            }.padding()*/
            
            Button("go home") {
                navigationVM.pushScreen(route: .home)
            }.padding()
            Button("logout") {
                authVM.signOut(navigationVM: navigationVM)
                navigationVM.pushScreen(route: .signIn)
            }
        }/*
        .onAppear {
                    Task {
                        do {
                            try await authVM.loadUserData()
                            name = authVM.name
                            lastName = authVM.currentUser?.lastName ?? ""
                        } catch {
                            // Обработка ошибок
                        }
                    }
                }*/
    }
}

#Preview {
    ProfileSetupScreen()
}
