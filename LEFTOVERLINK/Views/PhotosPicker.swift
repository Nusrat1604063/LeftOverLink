//
//  PhotosPicker.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 8/7/25.
//

import SwiftUI
import PhotosUI

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
    
    @Published private(set) var selectedFoodImage: UIImage? = nil
    @Published var foodImageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: foodImageSelection, for: .food)
        }
    }
    
    
    private func setImage(from selection: PhotosPickerItem?, for purpose: ImagePurpose) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                switch purpose {
                case .profile:
                    self.selectedProfileImage = uiImage
                case .food:
                    self.selectedFoodImage = uiImage
                }
            }
        }
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
                matching: PHPickerFilter.images,
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
                matching: PHPickerFilter.images,
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
