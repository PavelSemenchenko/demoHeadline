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
    @State private var showAlert = false // ok update
    
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
                            guard !name.isEmpty, !lastName.isEmpty else { return }
                            Task {
                                await repository.setUserInfo(name: name, lastName: lastName)
                                showAlert = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                showAlert = false
                                }
                            }
                        }
                        .padding()
                        .alert(isPresented: $showAlert) {
                                        Alert(title: Text("Success"), message: Text("User information saved successfully!"), dismissButton: .default(Text("OK")))
                                    }
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
    let authVM = AuthVM()
    let navigationVM = NavigationRouter()
    let repository = UserRepository()

    return ProfileSetupScreen()
        .environmentObject(authVM)
        .environmentObject(navigationVM)
        .environmentObject(repository)
}
