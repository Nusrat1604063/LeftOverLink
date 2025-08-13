//
//  DonationPostCradView.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 15/7/25.
//

import SwiftUI

struct DonationPostCardView: View {
    let post: DonationPost

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: - Profile Section
            HStack(alignment: .center, spacing: 8) {
                if !post.profileImageURL.isEmpty, let url = URL(string: post.profileImageURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.username)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(relativeTime(from: post.timestamp))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            // MARK: - Main Food Image
            if let url = URL(string: post.imageurl), !post.imageurl.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            // MARK: - Description Section
            VStack(alignment: .leading, spacing: 4) {
                Text(post.foodname)
                    .font(.title3)
                    .bold()
                Text("Portion: \(post.portion)")
                    .font(.subheadline)
                Text("Dietary: \(post.dietarytag)")
                    .font(.subheadline)
                Text("Location: \(post.location)")
                    .font(.subheadline)
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 4)
    }

    // Helper: Format relative time like "2 hours ago"
    private func relativeTime(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}


#Preview {
    //DonationPostCardView()
}
