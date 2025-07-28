//
//  PostFoodViewModel.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 12/7/25.
//

import Foundation
import FirebaseStorage
import Firebase
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class PostFoodViewModel: ObservableObject {
    
    enum DietaryTag: String, CaseIterable {
        case halal
        case vegan
        case meat
    }
    // Form state variables
    @Published  var selectedDiet: DietaryTag = .halal
    @Published  var foodName: String = ""
    @Published  var portion: Int = 1
    @Published  var location: String = ""
    
    @Published var photoPickerVM = photoPickerViewModel()
    
    func formValid() -> Bool {
        return photoPickerVM.selectedFoodImage != nil && !foodName.isEmpty  && portion > 0 && !location.isEmpty
        
    }
    
    func fetchCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        // Step 1: Check if a user is logged in and get their UID
        guard let uid = Auth.auth().currentUser?.uid else {
            // If no logged-in user, return an error using completion
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        // Step 2: Get a reference to the Firestore database
        let db = Firestore.firestore()
        
        // Step 3: Try to get the user profile document with the UID
        db.collection("userProfiles").document(uid).getDocument { documentSnapshot, error in
            // Step 4: Check if there was an error fetching the document
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Step 5: Check if the document exists and has data
            guard let document = documentSnapshot, document.exists, let data = document.data() else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])))
                return
            }
            
            // Step 6: Try to convert the data dictionary into your UserProfile model
            do {
                // ✅ This returns a non-optional object now
                let userProfile = try document.data(as: UserProfile.self)
                completion(.success(userProfile))
            } catch {
                completion(.failure(error))
            }
        }
    }


    
    func uploadFoodImageAndSavePost() {
        // 1. Start image upload to Supabase
        photoPickerVM.uploadFoodImageToSupabase { result in
            switch result {
            case .success(let imageUrl):
                print("✅ Image uploaded successfully: \(imageUrl)")
                
                // 2. Fetch current user's profile (name + profile image)
                self.fetchCurrentUserProfile { profileResult in
                    switch profileResult {
                    case .success(let userProfile):
                        
                        // 3. Create a new DonationPost with user and image info
                        let newPost = DonationPost(
                            id: nil,
                            foodname: self.foodName,
                            portion: self.portion,
                            dietarytag: self.selectedDiet.rawValue,
                            location: self.location,
                            imageurl: imageUrl,
                            timestamp: Date(),
                            username: userProfile.name,
                            profileImageURL: userProfile.profileImageUrl
                        )
                        
                        // 4. Save the post to Firestore
                        self.savePostToFirestore(newPost) { result in
                            switch result {
                            case .success:
                                print("✅ Post saved successfully")
                                self.resetForm()
                            case .failure(let error):
                                print(" Failed to save post: \(error)")
                            }
                        }
                        
                    case .failure(let error):
                        print(" Failed to fetch user profile: \(error)")
                    }
                }
                
            case .failure(let error):
                print("Image upload failed: \(error)")
            }
        }
    }

    
    func resetForm() {
        foodName = ""
        portion = 1
        selectedDiet = DietaryTag.halal
        location = ""
        photoPickerVM.selectedFoodImage = nil
        
    }
    
    // have to append post in an array so that this can be showed
    func savePostToFirestore(_ post: DonationPost, completion: @escaping (Result<Void, Error>) -> Void) {
            let db = Firestore.firestore()
            let postId = UUID().uuidString
            db.collection("donationPosts").document(postId).setData(post.toDictionary()) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
}
