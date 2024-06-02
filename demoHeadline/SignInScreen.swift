//
//  SignInScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI

struct SignInScreen: View {
    
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
                TextField("Phone number, username or email address", text: $name)
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
                    SecureField("Password", text: $password)
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
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .phoneNumber
                        }
                } else {
                    TextField("Password", text: $password)
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
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .phoneNumber
                        }
                }
                /*
                 TextField("Phone Number", text: $phoneNumber)
                 .keyboardType(.numberPad)
                 .padding()
                 .frame(height: 44)
                 .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray, lineWidth: 1))
                 .padding(.horizontal)
                 .focused($focusedField, equals: .phoneNumber) // Привязка к состоянию фокуса
                 //.submitLabel(.done)
                 .toolbar {
                 ToolbarItemGroup(placement: .keyboard) {
                 Spacer()
                 Button("Done") {
                 // Закрытие клавиатуры и переход на другой экран
                 focusedField = nil
                 //showingNextScreen = true
                 }
                 }
                 }
                 */
                NavigationLink(destination: SignUpScreen()) {
                    Text("Forgot password ?")
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                
                Spacer().frame(maxHeight: 20)
                HStack {
                    Spacer()
                    NavigationLink(destination: SignInScreen()) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                            )
                            /*.overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )*/
                    }
                    /*
                     Spacer()
                     */
                    
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
                            //.padding()
                            //.frame(width: UIScreen.main.bounds.width * 0.9)
                        /*.background(
                         RoundedRectangle(cornerRadius: 10)
                         .fill(Color.blue)
                         )
                         .overlay(
                         RoundedRectangle(cornerRadius: 10)
                         .stroke(Color.black, lineWidth: 2)
                         )*/
                    }
                }//.padding()
                /*
                 HStack(spacing: 0) {
                 Text("You agree with ")
                 //.fontWeight(.bold)
                 .foregroundColor(Color.gray)
                 .font(.system(size: 12))
                 
                 Text("Terms of use,")
                 .fontWeight(.bold)
                 .underline()
                 .font(.system(size: 12))
                 .onTapGesture {
                 if let url = URL(string: "https://headline.team") {
                 UIApplication.shared.open(url)
                 }
                 }
                 Text(" Privacy Policy")
                 .fontWeight(.bold)
                 .foregroundColor(Color.red)
                 .font(.system(size: 12))
                 .onTapGesture {
                 showingPrivacyScreen = true
                 }
                 }
                 .padding()*/
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

#Preview {
    SignInScreen()
}
