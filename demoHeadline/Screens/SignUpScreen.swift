//
//  SignUpScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI

struct SignUpScreen: View {
    @EnvironmentObject private var authVM : AuthVM
    @EnvironmentObject private var navigationVM : NavigationRouter
    
    @State var name: String = ""
    @State var password: String = ""
    @State var isSecure: Bool = true
    @State var phoneNumber: String = ""
    
    @FocusState private var focusedField: Field?
    enum Field {
        case name
        case phoneNumber
        case password
        
    }
    @State private var showingPrivacyScreen = false
    @State private var authenticationFailed = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Join us")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding()
                
                TextField("Username or email address", text: $authVM.name)
                    .padding()
                    .frame(height: 44)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                    .padding(.horizontal)
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .phoneNumber
                    }
                ZStack(alignment: .leading) {
                    Text("+380")
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                        .opacity(phoneNumber.isEmpty || phoneNumber == "+380" ? 1 : 0)
                    
                    TextField("", text: Binding(
                        get: { phoneNumber },
                        set: { newValue in
                            if newValue.hasPrefix("+380") {
                                phoneNumber = newValue
                            } else {
                                phoneNumber = "+380" + newValue
                            }
                        })
                    )
                    .keyboardType(.numberPad)
                    .padding()
                    .frame(height: 44)
                    //.background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                    //.padding(.horizontal)
                    .foregroundColor(.black)
                    .focused($focusedField, equals: .phoneNumber)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                    .toolbar {
                        if focusedField == .phoneNumber {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Next") {
                                    focusedField = .password
                                }
                            }
                        }
                    }
                }.background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                    .padding()
                
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
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 8)
                            }
                        )
                        .frame(height: 44)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                        .padding(.horizontal)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = nil
                        }
                } else {
                    TextField("Password", text: $authVM.password)
                    //.foregroundColor(.white)
                        .padding()
                        .overlay(
                            HStack {
                                Spacer()
                                Button(action: {
                                    isSecure.toggle()
                                }) {
                                    Image(systemName: isSecure ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 8)
                            }
                        )
                        .frame(height: 44)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                        .padding(.horizontal)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                        .onSubmit {
                            focusedField = nil
                        }
                }
                
                Spacer().frame(maxHeight: 20)
                HStack {
                    Spacer()
                    SignButton(text: "Sign Up", enabled: authVM.canSignUp, busy: authVM.busy) {
                        Task {
                            await authVM.signUp()
                            if authVM.isAuthenticated {
                                navigationVM.pushScreen(route: .home)
                            }
                        }
                    }/*
                      NavigationLink(destination: SignUpScreen()) {
                      Text("Sign Up")
                      .foregroundColor(.white)
                      .padding()
                      .frame(width: UIScreen.main.bounds.width * 0.9)
                      .background(
                      RoundedRectangle(cornerRadius: 10)
                      .fill(Color.blue)
                      )
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
                NavigationLink(destination: SignUpScreen()) {
                    Text("Log with + ")
                        .foregroundColor(.white)
                        .padding()
                }
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("By signing up, you agree to our ")
                    //.fontWeight(.bold)
                        .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.75))
                        .font(.system(size: 12))
                    
                    Text("Terms of use,")
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.75))
                        .underline()
                        .font(.system(size: 12))
                        .onTapGesture {
                            if let url = URL(string: "https://headline.team") {
                                UIApplication.shared.open(url)
                            }
                        }
                    Text(" Privacy Policy")
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.75))
                        .underline()
                        .font(.system(size: 12))
                        .onTapGesture {
                            showingPrivacyScreen = true
                        }
                }
                .padding()
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 1)
                
                HStack{
                    Text("Already have an account?")
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.75).opacity(0.8))
                        .font(.system(size: 12))
                    
                    NavigationLink(destination: SignInScreen()) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                
            }.sheet(isPresented: $showingPrivacyScreen) {
                PrivacyScreen()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.indigo, Color.red ]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
    
}


#Preview {
        SignUpScreen()
        .environmentObject(AuthVM())
        .environmentObject(NavigationRouter())
        //.environmentObject(UserRepository())
}
