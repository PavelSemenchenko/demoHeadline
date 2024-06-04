//
//  EmailTextField.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 04.06.2024.
//

import SwiftUI

struct EmailTextField: View {
    
    var valid: Bool
    var placeholder: String
    var text: Binding<String>
    private var backgroundColor: Color {
        valid ? .white : .red
    }
    
    var body: some View {
        TextField(placeholder, text: text)
            .keyboardType(.emailAddress)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding()
            .frame(height: 44)
            .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.white, lineWidth: 1))
            .padding(.horizontal)
            
    }
}

 #Preview {
     EmailTextField(valid: true, placeholder: "enter text", text: .constant("0001"))
 }
