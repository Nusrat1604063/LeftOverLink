//
//  userprofile.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 13/7/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct UserProfile: Identifiable, Codable {
    var documentId: String?
    
    var id: String {
        documentId ?? uid
    }
    var uid: String
    var name: String
    var bio: String
    var location: Location
    var locationName: String
    var profileImageUrl: String
    var createdAt: Date
 
}

struct Location: Codable {
    var lat: Double
    var lng: Double
}

extension UserProfile {
    func toDictionary()->[String: Any] {
        return [
            "uid": uid,
            "name": name,
            "bio": bio,
            "location": [
                "lat" : location.lat,
                "lng": location.lng],
            "locationName" : locationName,
            "profileImageUrl": profileImageUrl as Any,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
