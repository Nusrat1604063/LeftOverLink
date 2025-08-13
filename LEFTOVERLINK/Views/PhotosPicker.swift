//
//  PhotosPicker.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 8/7/25.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import Supabase

@MainActor
final class photoPickerViewModel: ObservableObject {
    
    enum ImagePurpose {
        case profile
        case food
    }
    
    @Published private(set) var selectedProfileImage: UIImage? = nil
    @Published var profileImageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: profileImageSelection, for: .profile)
        }
    }
    
    @Published  var selectedFoodImage: UIImage? = nil
    @Published var foodImageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: foodImageSelection, for: .food)
        }
    }
    
    
    private func setImage(from selection: PhotosPickerItem?, for purpose: ImagePurpose) {
        guard let selection else { return }

        Task {
            do {
                guard let data = try await selection.loadTransferable(type: Data.self) else {
                    print("❌ Failed to get image data")
                    return
                }

                guard let image = UIImage(data: data),
                      image.size.width > 0,
                      image.size.height > 0,
                      image.size.width.isFinite,
                      image.size.height.isFinite else {
                    print("❌ Image is invalid (size or data corrupted)")
                    return
                }

                switch purpose {
                case .profile:
                    self.selectedProfileImage = image
                case .food:
                    self.selectedFoodImage = image
                }

            } catch {
                print("❌ Error loading image: \(error.localizedDescription)")
            }
        }
    

        
    }


}

extension photoPickerViewModel {
    
    func uploadImageToSupabase(image: UIImage?, folder: String, completion: @escaping (Result<String, Error>) -> Void) {
        let bucket = "leftoverlink-donation-post-image"
        let projectRef = "dvfdshfhxwomxqazflzw"
        
        guard let image = image else {
            completion(.failure(NSError(domain: "No image selected", code: 0)))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Image conversion failed", code: 0)))
            return
        }
        
        let fileName = UUID().uuidString + ".jpg"
        let path = "\(folder)/\(fileName)"
        
        Task {
            do {
                let supabase = SupabaseManager.shared.client
                _ = try await supabase.storage
                    .from(bucket)
                    .upload(path, data: imageData)
                
                let publicUrl = "https://\(projectRef).supabase.co/storage/v1/object/public/\(bucket)/\(path)"
                print("✅ Uploaded to Supabase: \(publicUrl)")
                completion(.success(publicUrl))
            } catch {
                print("Upload failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

extension photoPickerViewModel {
    
    func uploadFoodImageToSupabase(completion: @escaping (Result<String, Error>) -> Void) {
        uploadImageToSupabase(image: selectedFoodImage, folder: "posts", completion: completion)
    }
    
    func uploadProfileImageToSupabase(completion: @escaping (Result<String, Error>) -> Void) {
        uploadImageToSupabase(image: selectedProfileImage, folder: "profiles", completion: completion)
    }
}


struct ProfilePhotoPickerView: View {
    @ObservedObject var viewModel: photoPickerViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Image or placeholder (circular)
            Group {
                if let profileImage = viewModel.selectedProfileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(width: 150, height: 150)
            .clipShape(Circle()) // Apply only to image
            .shadow(radius: 4)
            
            // Floating + icon (positioned and visible)
            PhotosPicker(
                selection: $viewModel.profileImageSelection,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.blue)
                    .background(Color.white.clipShape(Circle()))
                    .shadow(radius: 2)
                    .offset(x: 5, y: 5) // Push it slightly out of the image
            }
        }
        .frame(width: 160, height: 160) // slightly larger frame to allow overflow
    }
}





struct FoodPhotoPickerView: View {
    @ObservedObject var viewModel: photoPickerViewModel
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let foodImage = viewModel.selectedFoodImage {
                    Image(uiImage: foodImage)
                        .resizable()
                        .scaledToFill()
                        .onAppear {
                            print("✅ Showing image size: \(foodImage.size)")
                        }
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(width: 320, height: 200)
            .cornerRadius(20)
            .clipped()
            
            PhotosPicker(
                selection: $viewModel.foodImageSelection,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
                    .background(Color.white.clipShape(Circle()))
                    .padding(8)
            }
        }
    }
}


struct ParentView: View {
    @StateObject private var photoPickerVM = photoPickerViewModel()
    
    var body: some View {
        VStack {
            ProfilePhotoPickerView(viewModel: photoPickerVM)
            
            Divider().padding(.vertical, 30)
            
            FoodPhotoPickerView(viewModel: photoPickerVM)
        }
        .padding()
    }
}






#Preview {
    ParentView()
}
