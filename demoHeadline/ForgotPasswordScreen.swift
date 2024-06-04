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
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                loginVM.forgotPassword(email: email)
                // Выполните здесь логику сброса пароля
                // В этом примере мы просто выведем в консоль email для сброса пароля.
                print("Запрос на сброс пароля для email: \(email)")
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
    ForgotPasswordScreen()
}
