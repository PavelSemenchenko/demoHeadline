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
    }
    
}
