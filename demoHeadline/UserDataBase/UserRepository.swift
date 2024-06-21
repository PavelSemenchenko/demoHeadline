//
//  UserRepository.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 09.06.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift

class UserRepository: ObservableObject {
    //var navigationVM: NavigationRouter!
    @Published var name = "..."
    @Published var lastName = "..."
    
    @MainActor func setUserInfo(name: String, lastName: String) async {
        guard let currentUID = Auth.auth().currentUser?.uid else {
                    print("User ID is nil.")
                    return
                }
                let db = Firestore.firestore()
                let userRef = db.collection("profiles").document(currentUID)
                do {
                    try await userRef.setData([
                        "name": name,
                        "lastName": lastName,
                        "userId": currentUID
                    ])
                    print("User info successfully set.")
                } catch {
                    print("Error setting user info: \(error.localizedDescription)")
                }
        /*
        if let currentUID = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let userRef = db.collection("profiles").document(currentUID)
            do {
                try await userRef.setData(["name" : name,
                                           "lastName": lastName,
                                           "userId": currentUID]) { error in
                    if let error = error {
                        print("Error adding username to Firestore: \(error.localizedDescription)")
                    } else {
                        print("Username added to Firestore successfully.")
                    }
                }
                print("User info successfully set.")
               //navigationVM.pushHome()
            } catch {
                print("Error adding username to Firestore: \(error.localizedDescription)")
            }
        } else {
            print("Current user ID is nil.")
        }*/
    }
    
    @MainActor func getUserInfo() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            return print ("John Doe")
        }
        let db = Firestore.firestore()
                let userRef = db.collection("profiles").document(userId)
                do {
                    let document = try await userRef.getDocument()
                    if let data = document.data() {
                        self.name = data["name"] as? String ?? "Unknown"
                        self.lastName = data["lastName"] as? String ?? "Unknown"
                        print("User info successfully fetched.")
                    } else {
                        print("User document does not exist.")
                    }
                } catch {
                    print("Error fetching user info: \(error.localizedDescription)")
                }
        /*        do {
            // взяли снимок из коллекции с текущим идентификатором пользователя
            let querySnapshot = try await Firestore.firestore()
                .collection("profiles")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            // Проверяем, есть ли документы
            guard !querySnapshot.isEmpty else {
                print("No documents found for user with ID: \(userId)")
                return
            }
            
            // Получаем данные первого документа
            if let document = querySnapshot.documents.first {
                // Преобразуем данные документа в объект UserEntity
                if let contact = try? document.data(as: UserEntity.self) {
                    // Обновляем значение @Published var name
                    self.name = contact.name //?? "John Doe"
                    self.lastName = contact.lastName
                    self.objectWillChange.send()
                } else {
                    print("Failed to decode Contact from document data")
                }
            } else {
                print("No documents found for user with ID: \(userId)")
            }
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
        }*/
    }
    
}
