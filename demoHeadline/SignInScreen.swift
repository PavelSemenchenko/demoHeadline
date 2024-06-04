//
//  SignInScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI

struct SignInScreen: View {
    @StateObject private var authViewModel = AuthVM()
    @EnvironmentObject var navigationVM : NavigationRouter
    @State var name: String = ""
    @State var password: String = ""
    @State var isSecure: Bool = true
    @State var phoneNumber: String = "+380"
    
    @FocusState private var focusedField: Field?
    enum Field {
        case name
        case password
        case phoneNumber
    }
    
    @State private var showingPrivacyScreen = false
    @State private var authenticationFailed = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Wellcome back")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding()
                TextField("Email address", text: $authViewModel.email)
                    .padding()
                    .frame(height: 44)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.white, lineWidth: 1))
                    .padding(.horizontal)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                
                if isSecure {
                    SecureField("Password", text: $authViewModel.password)
                        .padding()
                        .overlay(
                            HStack {
                                Spacer()
                                Button(action: {
                                    isSecure.toggle()
                                }) {
                                    Image(systemName: isSecure ? "eye.slash" : "eye")
                                        .foregroundColor(.white)
                                }
                                .padding(.trailing, 8)
                            }
                        )
                        .frame(height: 44)
                        .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.white, lineWidth: 1))
                        .padding(.horizontal)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = nil
                        }
                } else {
                    TextField("Password", text: $authViewModel.password)
                        .padding()
                        .overlay(
                            HStack {
                                Spacer()
                                Button(action: {
                                    isSecure.toggle()
                                }) {
                                    Image(systemName: isSecure ? "eye.slash" : "eye")
                                        .foregroundColor(.white)
                                }
                                .padding(.trailing, 8)
                            }
                        )
                        .frame(height: 44)
                        .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.white, lineWidth: 1))
                        .padding(.horizontal)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = nil
                        }
                }
                NavigationLink(destination: ForgotPasswordScreen()) {
                    Text("Forgot password ?")
                        .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.75))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                
                Spacer().frame(maxHeight: 20)
                
                HStack {
                    Spacer()
                    
                    
                    Button(action: {
                        Task {
                            await authViewModel.signIn()
                            //navigationVM.pushScreen(route: .home)
                            navigationVM.pushHome()
                        }
                    }) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                            )
                    }
                        Spacer()
                    }.padding()
                    HStack{
                        VStack{
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 1)
                        }
                        Text("OR").foregroundStyle(Color.white)
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 1)
                    }.padding()
                NavigationLink("Show Detail View") {
                    HomeScreen()
                    //navigationVM.pushHome()
                }
                Button(action: {
                    Task {
                        await authViewModel.signIn()
                        navigationVM.pushScreen(route: .home)
                    }
                    print("----- is auth \(authViewModel.isAuthenticated)")
                }) {
                    Text("go2")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                }
                    
                    Spacer()
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 1)
                    
                    HStack{
                        Text("Don't have an account?")
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                            .font(.system(size: 12))
                        
                        NavigationLink(destination: SignUpScreen()) {
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }.sheet(isPresented: $showingPrivacyScreen) {
                    PrivacyScreen()
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.red, Color.orange]),
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    /*
    #Preview {
        SignInScreen()
    }*/
