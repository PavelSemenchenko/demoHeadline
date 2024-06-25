//
//  GrayButton.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 25.06.2024.
//

import SwiftUI
fileprivate struct GrayButtonStyle: ButtonStyle {
    let color: Color
    let width: CGFloat
        let height: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .padding()
            .frame(width: width, height: height)
            //.frame(width: UIScreen.main.bounds.width * 0.9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
            )
    }
}

struct GrayButton: View {
    let text: String
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat
    
    private var color: Color {
        var color: Color = Color(white: 0.9) // Светло-серый цвет
        return color
    }
    
    var body: some View {
        Button(text, action: action)
            .buttonStyle(GrayButtonStyle(color: color, width: width, height: height))
         /*
        NavigationLink("Bloop") {
            ProfileSetupScreen()
                .buttonStyle(GrayButtonStyle(color: color, width: width, height: height))
          
        }*/
    }
}

#Preview {
    GrayButton(text: "text", action: {}, width: 150, height: 40)
}
