//
//  GreyButton.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 25.06.2024.
//

import SwiftUI
fileprivate struct GrayButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
        )
            
    }
}
struct GreyButton: View {
    let text: String
    let action: () -> Void
    
    private var color: Color {
        var color: Color = .gray
        return color
    }
    
    var body: some View {
        Button(text, action: action)
            .buttonStyle(GrayButtonStyle(color: color))
    }
}

#Preview {
    GreyButton(text: "text", action: {})
}
