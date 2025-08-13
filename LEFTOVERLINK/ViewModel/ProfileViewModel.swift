//
//  ProfileViewModel.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 13/7/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var bio: String = ""
    @Published var photoPickerVM = photoPickerViewModel()
    
    @Published var isLoading = false
    @Published var existingProfile: Bool = false
    @Published var profileImageUrl: String? = nil
    @Published var location: Location = Location(lat: 0, lng: 0)
    @Published var displayName: String = ""
    
    private let db = Firestore.firestore()

    // MARK: - Load Profile
    func loadProfileIfExists() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("Loading profile for user: \(uid)")
        isLoading = true
        defer { isLoading = false }

        do {
            let snapshot = try await db.collection("userProfiles").document(uid).getDocument()
            if let data = snapshot.data() {
                name = data["name"] as? String ?? ""
                address = data["address"] as? String ?? ""
                bio = data["bio"] as? String ?? ""
                profileImageUrl = data["profileImageUrl"] as? String
                self.existingProfile = !name.isEmpty && !address.isEmpty && !bio.isEmpty
                print("value of existingProfile do block: \(existingProfile)")
            } else {
                existingProfile = false
                print("value of existingProfile else block: \(existingProfile)")
            }
        } catch {
            print(" Failed to fetch profile: \(error.localizedDescription)")
        }
    }

    // MARK: - Save Profile
    func uploadImageAndSaveProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        isLoading = true

        photoPickerVM.uploadProfileImageToSupabase { result in
            Task { @MainActor in  //before we have fecthed data from firestore which may be in background thread
                                    //you're not sure which thread your async callback is using, and you need to update UI state — wrap it in Task { @MainActor in }
                switch result {
                case .success(let imageUrl):
                    self.profileImageUrl = imageUrl
                    let newProfile = UserProfile(
                        documentId: nil,
                        uid: uid,
                        name: self.name,
                        address: self.address,
                        bio: self.bio,
                        location: self.location,
                        profileImageUrl: imageUrl,
                        createdAt: Date()
                    )

                   await self.saveProfileToFirestore(profile: newProfile)

                case .failure(let error):
                    self.isLoading = false
                    print("❌ Upload failed: \(error.localizedDescription)")
                }
            }
        }
    }

    private func saveProfileToFirestore(profile: UserProfile) async {
        isLoading = true
        defer {isLoading = false}
        
        let db = Firestore.firestore()
        guard let uid = profile.uid as String? else {
            print("Invalid UID")
            return
        }
        do {
            try await db.collection("userProfiles")
                .document(uid)
                .setData(profile.toDictionary())
            print("✅ Profile saved successfully")
            existingProfile = true
        } catch {
            print(" Failed to save profile: \(error.localizedDescription)")
        }
        
    }
}
