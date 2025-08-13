//
//  DonationPostViewModel.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 17/7/25.
//

import SwiftUI
import FirebaseFirestore

class DonationPostViewModel: ObservableObject {
    @Published var posts: [DonationPost] = []
    private let db = Firestore.firestore()
    
    func fetchPosts() {
        print("Fetching posts...")
        db.collection("donationPosts")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching posts:", error)
                    return
                }
                print("Fetched posts.")
                self.posts = snapshot?.documents.compactMap {
                    try? $0.data(as: DonationPost.self)
                } ?? []
            }
    }
}
