//
//  SignInScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI

struct SignInScreen: View {
    @EnvironmentObject private var authVM : AuthVM
    @EnvironmentObject private var navigationVM : NavigationRouter
    @State var name = ""
    @State var password = ""
    @State var isSecure = true
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
        //NavigationStack {
            VStack {
                Spacer()
                Text("Wellcome back")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding()
                
                EmailTextField(valid: true, placeholder: "Email address", text: $authVM.email)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                /*
                TextField("", text: $authVM.email)
                    .padding()
                    .frame(height: 44)
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.white, lineWidth: 1))
                    .padding(.horizontal)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }*/
                
                if isSecure {
                    SecureField("Password", text: $authVM.password)
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
                    TextField("Password", text: $authVM.password)
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
                    SignButton(text: "Log In", enabled: authVM.canLogin, busy: authVM.busy) {
                        Task {
                            await authVM.signIn()
                            print("+++++++++ \(authVM.userID)")
                            if authVM.isAuthenticated {
                                navigationVM.pushScreen(route: .home)
                            }
                        }
                    }
                    /*
                    Button(action: {
                                    Task {
                                        await authVM.signIn()
                                        print("+++++++++ \(authVM.userID)")
                                        if authVM.isAuthenticated {
                                            navigationVM.pushScreen(route: .home)
                                        }
                                    }
                                }) {
                                    Text("Log In")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                        .frame(maxWidth: .infinity)
                                }
                                .disabled(authVM.email.isEmpty || authVM.password.isEmpty)
                                .padding()*/
                    /*
                    SignButton(text: "Log In", enabled: true, busy: false) {
                        Task {
                            await authVM.signIn(navigationVM: NavigationRouter())
                            print("+++++++++ \(authVM.userID)")
                            navigationVM.pushScreen(route: .home)
                        }
                    }*/
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
            //}
        }
    }
    
    #Preview {
        SignInScreen()
            .environmentObject(NavigationRouter())
                    .environmentObject(AuthVM())
    }
