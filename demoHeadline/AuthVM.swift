//
//  AuthVM.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import Foundation
import FirebaseAuth

class AuthVM: ObservableObject {
    @Published var email: String = "test@test.com"
    @Published var password: String = "123456"
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    @Published var userID: String?
    @Published var busy: Bool = false    //@ObservableObject var authViewModel = AuthVM()
    //@StateObject var navigationVM = NavigationRouter()

    var isEmailCorrect: Bool {
        email.contains("@")
    }
    var isPaswordCorrect: Bool {
        get {
            return password.count >= 6
        }
    }
    var canLogin: Bool {
        return isEmailCorrect && isPaswordCorrect
    }
    func forgotPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    class var isAuthenticated: Bool {
        print(Auth.auth().currentUser?.uid)
        return Auth.auth().currentUser != nil
    }
    @MainActor func signIn() async {
        busy = true
        do {
            let result = try? await Auth.auth().signIn(withEmail: email, password: password)
            //go next
        } catch {
            
        }
        busy = false
    }

    @MainActor func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            userID = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

