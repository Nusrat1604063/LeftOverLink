//
//  LeftoverPost.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 9/7/25.
//

import Foundation
import FirebaseFirestore

struct DonationPost : Codable, Identifiable {
    var documentId: String?
    
    var id: String {
        documentId ?? UUID().uuidString
    }
    
    let foodName: String
    let portion: Int
    let dietaryTag: String
    let location: String
    let imageURL: String
    let timestamp: Date
    let userName: String
    let profileImageURL: String
 
}

extension DonationPost {
    func toDictionary()  -> [String:Any] {
        return[
            "foodname" : foodName,
            "portion" : portion,
            "dietarytag" : dietaryTag,
            "location" : location,
            "imageurl" : imageURL,
            "timestamp" : Timestamp(date: timestamp),
            "username": userName,
            "profileImageURL": profileImageURL 
        ]
    }
}
