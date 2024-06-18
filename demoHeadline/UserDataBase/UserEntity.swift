//
//  UserModel.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 09.06.2024.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserEntity: Codable, Hashable ,Identifiable {
    @DocumentID var id: String?
    var email: String
    var name: String
    var lastName: String
    var createdAt: Date
    
    func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "name": name,
            "lastName": lastName,
            "createdAt": createdAt
        ]
    }
}
