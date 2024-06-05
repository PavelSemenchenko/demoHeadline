//
//  AuthVM.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift

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
    
    func signIn() async {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isAuthenticated = false
                }
            }
        }
    func getCurrentUserID() -> String? {
            if let userID = Auth.auth().currentUser?.uid {
                print("User ID: \(userID)")
                return userID
            } else {
                print("No user is currently signed in.")
                return nil
            }
        }
    
    /*
    @MainActor func signIn(navigationVM: NavigationRouter) async {
        busy = true
        do {
            //let result =
            try await Auth.auth().signIn(withEmail: email, password: password)
            navigationVM.pushScreen(route: .home)
        } catch {
            errorMessage = "Ошибка входа: \(error.localizedDescription)"
            //showError = true
            //print("00000\(showError)")
            print("\(#file) \(#function) \(error)")
        }
        busy = false
    }
     */

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

