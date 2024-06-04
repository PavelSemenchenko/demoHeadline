//
//  PasswordTextField.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 04.06.2024.
//

import SwiftUI

struct PasswordTextField: View {
    var valid: Bool
    var placeholder: String
    var text: Binding<String>
    private var backgroundColor: Color {
        valid ? .white : .red
    }
    
    var body: some View {
        TextField(placeholder, text: text)
        .border(backgroundColor)
        .cornerRadius(5)
        .textFieldStyle(.roundedBorder)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        .background(backgroundColor)
            .autocapitalization(.words)
            .padding(EdgeInsets(top: 8, leading: 36, bottom: 8, trailing: 36))
            .cornerRadius(16)
    }
}

#Preview {
    PasswordTextField(valid: true, placeholder: "123456", text: .constant("002"))
}
