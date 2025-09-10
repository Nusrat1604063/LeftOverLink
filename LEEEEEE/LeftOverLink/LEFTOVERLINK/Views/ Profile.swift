//
//  Profile.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 30/6/25.
//

import SwiftUI

struct Profile: View {
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var appstate: Appstate
    @State private var showMap = false

    var body: some View {
        ZStack {
            // Main Scroll Content
            ScrollView {
                VStack(spacing: 20) {
                    ProfilePhotoPickerView(viewModel: viewModel.photoPickerVM)
                        .padding(.top, 40)

                    if viewModel.existingProfile {
                        // Read-only profile info
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(viewModel.name)")
                                .font(.headline)
                            HStack {
                                Text("Bio:")
                                    .font(.headline)
                                Text(viewModel.bio)
                                    .font(.body)
                            }
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                Text(viewModel.locationName)
                            }
                        }
                        .padding()
                        Spacer()
                    } else {
                        // Editable profile form
                        TextField("Name", text: $viewModel.name)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)

                        TextEditor(text: $viewModel.bio)
                            .frame(height: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal)

                        Button(action: { showMap = true }) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                        }
                        .sheet(isPresented: $showMap) {
                            MapView(mapPurPose: .profile, profileViewModel: viewModel)
                        }

                        Spacer()

                        Button(action: {
                            Task { viewModel.uploadImageAndSaveProfile() }
                        }) {
                            Text(viewModel.isLoading ? "Saving..." : "Save Profile")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.isLoading ? Color.gray : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(viewModel.isLoading)
                        .padding()
                    }
                }
                .padding(.top, 60) // leave space for the floating button
            }
            .task { await viewModel.loadProfileIfExists() }

            // Floating Home Button (top-left, overlay)
            if viewModel.existingProfile {
                VStack {
                    HStack {
                        Button(action: { appstate.routes.append(.homepage) }) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.leading, 12)
                .padding(.top, 12)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    Profile()
        .environmentObject(Appstate())
}
