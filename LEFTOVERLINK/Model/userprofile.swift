//
//  userprofile.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 13/7/25.
//

import Foundation
import FirebaseCore
struct UserProfile: Identifiable, Codable {
    var documentId: String?
    
    var id: String {
        documentId ?? uid
    }
    var uid: String
    var name: String
    var address: String
    var bio: String
    var profileImageUrl: String
    var createdAt: Date
 
}

extension UserProfile {
    func toDictionary()->[String: Any] {
        return [
            "uid": uid,
            "name": name,
            "address": address,
            "bio": bio,
            "profileImageUrl": profileImageUrl as Any,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
