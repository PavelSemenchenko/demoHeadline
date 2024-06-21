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
        VStack {
            Form {
                Section {
                    HStack {
                        Text("Name")
                            .frame(width: 80, alignment: .leading)
                        TextField("Enter your first name", text: $name)
                            .textContentType(.givenName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                            .padding(.trailing)
                    }
                    HStack {
                        Text("Last name")
                            .frame(width: 80, alignment: .leading)
                        TextField("Enter your last name", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                            .padding(.trailing)
                    }
                    HStack {
                        Spacer()
                        Button("Save User Info") {
                            Task {
                                await repository.setUserInfo(name: name, lastName: lastName)
                            }
                        }
                        .padding()
                        /*
                         Button("Save Profile") {
                         guard !name.isEmpty, !lastName.isEmpty else { return }
                         Task {
                         do {
                         var service = UserRepository()
                         //service.navigationVM = navigationVM
                         try await service.setUserInfo(name: repository.name,
                         lastName: repository.lastName)
                         // Вызов метода для обновления имени пользователя
                         //try await authVM.updateName(name: name)
                         navigationVM.pushHome()
                         print("is saved ???????")
                         } catch {
                         // Обработка ошибок
                         }
                         }
                         }.padding()
                         */
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
        }.onAppear {
            Task {
                await repository.getUserInfo()
                self.name = repository.name
                self.lastName = repository.lastName
            }
        }
    }
}

#Preview {
    ProfileSetupScreen()
}
