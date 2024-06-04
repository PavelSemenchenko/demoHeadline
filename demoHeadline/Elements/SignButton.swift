//
//  SignButton.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 04.06.2024.
//

import SwiftUI
fileprivate struct SignButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
        )
            
    }
}

struct SignButton: View {
    let text: String
    let enabled: Bool
    let busy: Bool
    let action: () -> Void
    
    private var color: Color {
        var color: Color = enabled ? .blue : .red
        if busy {
            color = .orange
        }
        return color
    }
    var body: some View {
        Button(text, action: action)
            .buttonStyle(SignButtonStyle(color: color))
            .disabled(!enabled || busy)
    }
}

#Preview {
    SignButton(text: "Sign in", enabled: true, busy: false, action: {})
}
