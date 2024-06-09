//
//  ForgotPasswordScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI

struct ForgotPasswordScreen: View {
    @State private var email = ""
    @EnvironmentObject private var loginVM : AuthVM 
    
    var body: some View {
        VStack {
            Text("Введите ваш email для сброса пароля")
            
            TextField("Email", text: $loginVM.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                loginVM.forgotPassword(email: email)
            }) {
                Text("Сбросить пароль")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarTitle("Сброс пароля")
    }
}

#Preview {
    ForgotPasswordScreen().environmentObject(AuthVM())
}
