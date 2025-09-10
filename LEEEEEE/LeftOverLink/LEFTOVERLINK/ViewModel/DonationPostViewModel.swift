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
    private var listener: ListenerRegistration? // keep reference to detach later
    
    init() {
        listenToPosts()
    }
    
    deinit {
        // detach listener when ViewModel is deallocated
        listener?.remove()
    }
    
    func listenToPosts() {
        listener = db.collection("donationPosts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening for posts:", error)
                    return
                }
                
                self.posts = snapshot?.documents.compactMap {
                    try? $0.data(as: DonationPost.self)
                } ?? []
                
                print("Live posts updated. Count:", self.posts.count)
            }
    }
}
