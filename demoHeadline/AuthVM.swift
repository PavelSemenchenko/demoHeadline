//
//  AuthVM.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 02.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import FirebaseFirestoreSwift

class AuthVM: ObservableObject {
    @Published var email: String = "1test@test.com"
    @Published var password: String = "123456"
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    @Published var userID: String?
    @Published var busy: Bool = false    //@ObservableObject var authViewModel = AuthVM()
    //@StateObject var navigationVM = NavigationRouter()
    @Published var name: String = ""
    @Published var currentUser: UserEntity?
    private var db = Firestore.firestore()
    
    init() {
        loadAuthState()
    }
    private func saveAuthState() {
        UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        UserDefaults.standard.set(userID, forKey: "userID")
    }
    
    private func loadAuthState() {
        isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        userID = UserDefaults.standard.string(forKey: "userID")
    }
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
    var canSignUp: Bool {
            isEmailCorrect && isPaswordCorrect && !name.isEmpty
        }
    func forgotPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    class var isAuthenticated: Bool {
        print(Auth.auth().currentUser?.uid)
        return Auth.auth().currentUser != nil
    }
    
    @MainActor func signUp() async {
        busy = true
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let newUser = UserEntity(id: result.user.uid, email: email, name: name, createdAt: Date())
            try await db.collection("profiles").document(newUser.id!).setData(newUser.toDictionary())
            
            // Установка значения name после успешной регистрации
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.userID = newUser.id
                self.name = newUser.name // Установка имени пользователя
                self.currentUser = newUser
                self.saveAuthState()
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
        busy = false
    }
    @MainActor func updateName(name: String) async throws {
        guard let userID = userID else { return }
        
        // Обновление имени пользователя в Firestore
        try await db.collection("profiles").document(userID).setData(["name": name], merge: true)
        
        // Обновление имени в локальной переменной
        self.name = name
    }
    /*
    @MainActor func signUp() async {
            busy = true
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                let newUser = UserEntity(id: result.user.uid, email: email, name: name, createdAt: Date())
                try await db.collection("profiles").document(newUser.id!).setData(newUser.toDictionary())
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    self.userID = newUser.id
                    self.currentUser = newUser
                    self.saveAuthState()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
            busy = false
        }*/
         /*
         private func saveUserToFirestore(user: UserModel) async throws {
             try await db.collection("users").document(user.id ?? UUID().uuidString).setData(user.toDictionary())
         }
    */
    func signIn() async {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.userID = authResult.user.uid
                self.saveAuthState()
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
        
    func signOut(navigationVM: NavigationRouter) {
            do {
                try Auth.auth().signOut()
                isAuthenticated = false
                userID = nil
                saveAuthState()
                DispatchQueue.main.async {
                    navigationVM.popUntilSignInScreen()
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
}

