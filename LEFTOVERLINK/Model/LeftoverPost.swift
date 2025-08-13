//
//  LeftoverPost.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 9/7/25.
//

import Foundation
import FirebaseFirestore

struct DonationPost : Codable, Identifiable {
    @DocumentID var id: String?

        let foodname: String
        let portion: Int
        let dietarytag: String
        let location: String
        let imageurl: String
        let timestamp: Date
        let username: String
        let profileImageURL: String
 
}

extension DonationPost {
    func toDictionary()  -> [String:Any] {
        return[
            "foodname" : foodname,
            "portion" : portion,
            "dietarytag" : dietarytag,
            "location" : location,
            "imageurl" : imageurl,
            "timestamp" : Timestamp(date: timestamp),
            "username": username,
            "profileImageURL": profileImageURL
        ]
    }
}
