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

    var body: some View {
            ScrollView {
                
                VStack(spacing: 20) {
                    ProfilePhotoPickerView(viewModel: viewModel.photoPickerVM)
                        .padding(.top, 40)
                    
                    if viewModel.existingProfile {
                        // Show profile info in read-only form
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name: \(viewModel.name)")
                                .font(.headline)
                            Text("Address: \(viewModel.address)")
                                .font(.subheadline)
                            Text("Bio:")
                                .font(.headline)
                            Text(viewModel.bio)
                                .font(.body)
                        }
                        .padding()
                        Spacer()
                       
                    } else {
                        // Show editable form fields
                        TextField("Name", text: $viewModel.name)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                        
                        TextField("Address", text: $viewModel.address)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                        
                        TextEditor(text: $viewModel.bio)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                viewModel.uploadImageAndSaveProfile()
                            }
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
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
            }
            .task {
                await viewModel.loadProfileIfExists()
            }
        }
    }


#Preview {
    Profile()
        .environmentObject(Appstate())
}
