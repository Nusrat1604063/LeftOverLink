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
                // Extract values first
                let fetchedName = data["name"] as? String ?? ""
                let fetchedAddress = data["address"] as? String ?? ""
                let fetchedBio = data["bio"] as? String ?? ""
                let fetchedProfileImageUrl = data["profileImageUrl"] as? String
                let fetchedDisplayName = data["locationName"] as? String ?? ""
                let fetchedLocation = Location(
                    lat: data["location.lat"] as? Double ?? 0,
                    lng: data["location.lng"] as? Double ?? 0
                )

                // Update UI on main thread
                await MainActor.run {
                    name = fetchedName
                    address = fetchedAddress
                    bio = fetchedBio
                    profileImageUrl = fetchedProfileImageUrl
                    displayName = fetchedDisplayName
                    location = fetchedLocation
                    existingProfile = !name.isEmpty && !address.isEmpty && !bio.isEmpty
                    print("Loaded profileImageUrl:", profileImageUrl ?? "nil")
                }

                // Load image from URL into selectedProfileImage
                if let urlString = fetchedProfileImageUrl, let url = URL(string: urlString) {
                    Task {
                        do {
                            let (data, _) = try await URLSession.shared.data(from: url)   //downloads the image from URL so in task doing synchronously
                            if let image = UIImage(data: data) {
                                await MainActor.run {
                                    self.photoPickerVM.selectedProfileImage = image
                                    print("✅ Loaded profile image from URL")
                                }
                            }
                        } catch {
                            print("❌ Failed to load profile image from URL:", error)
                        }
                    }
                }
            } else {
                await MainActor.run { existingProfile = false }
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
                        locationName: self.displayName,
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

/*
 Because SwiftUI updates the UI only on the main thread, any change to a @Published property like profileImageUrl must happen on the main thread; otherwise, the view might not refresh.
 Firestore’s getDocument() runs on a background thread, so assigning directly from its snapshot can happen off the main thread.
 Wrapping it in MainActor.run ensures the UI updates correctly when the property changes.
 */
