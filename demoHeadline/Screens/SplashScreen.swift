//
//  SplashScreen.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import SwiftUI

struct SplashScreen: View {
    @State private var logoOpacity: Double = 0.0
    @State private var navigateToNextScreen = false
    
    var body: some View {
        NavigationView { 
            ZStack {
                LinearGradient(colors: [Color(red: 70/255, green: 70/255, blue: 70/255),
                                        Color(red: 200/255, green: 200/255, blue: 200/255),
                                        Color(red: 70/255, green: 70/255, blue: 70/255)],
                               startPoint: .bottomTrailing, endPoint: .topLeading)
                VStack {
                    Image("logo1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .opacity(logoOpacity)
                        .padding()
                    
                    Text("Hair  S P A")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(logoOpacity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5)) {
                    logoOpacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    navigateToNextScreen = true
                }
            }
            .background(NavigationLink(destination: SignInScreen(), isActive: $navigateToNextScreen) { EmptyView() })
            // Используем NavigationLink для автоматического перехода на следующий экран
        }
    }
}

#Preview {
    SplashScreen()
}
