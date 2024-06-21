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
    //@EnvironmentObject private var authVM: AuthVM
    @State private var name = ""
    @State private var lastName = ""
    
    var body: some View {
        VStack{
            Form {
                Section {
                    HStack {
                        Text("Name")
                            .frame(width: 80, alignment: .leading)
                        TextField("Enter your first name", text: $repository.name)
                            .textContentType(.givenName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                            .padding(.trailing)
                    }
                    HStack {
                        Text("Last name")
                            .frame(width: 80, alignment: .leading)
                        TextField("Enter your last name", text: $repository.lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                            .padding(.trailing)
                    }
                    HStack {
                        Spacer()
                        Button("Save Profile") {
                            guard !name.isEmpty, !lastName.isEmpty else { return }
                            Task {
                                do {
                                    var service = UserRepository()
                                    //service.navigationVM = navigationVM
                                    try await service.setUserInfo(name: authVM.name,
                                                                  lastName: authVM.lastName)
                                    // Вызов метода для обновления имени пользователя
                                    //try await authVM.updateName(name: name)
                                    navigationVM.pushHome()
                                    print("is saved ???????")
                                } catch {
                                    // Обработка ошибок
                                }
                            }
                        }.padding()
                        Spacer()
                    }
                }
            }.navigationBarTitle("Profile")
            
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
                    lastName = authVM.lastName
                    print("+++++++++++++++\(authVM.lastName)")
                } catch {
                    // Обработка ошибок
                    print("Error loading user data: \(error.localizedDescription)")
                }
            }
        }*/
    }
}

#Preview {
    ProfileSetupScreen()
}
