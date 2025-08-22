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
    @State private var showMap = false;
    
    var body: some View {
        ZStack(alignment: .topLeading) {  // top-left alignment for the button
            
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
                            HStack{
                                Image(systemName: "mappin.and.ellipse")
                                Text(viewModel.displayName)
                            }
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
                        
                        Button(action: { showMap = true }) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                        }
                        .sheet(isPresented: $showMap) {
                            MapView(profileViewModel: viewModel)
                        }
                        
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
                .padding(.top, 60) // leave space for the floating home button
            }
            .task {
                await viewModel.loadProfileIfExists()
            }
            
            // Floating Home Button (top-left)
            if viewModel.existingProfile {
                Button(action: { appstate.routes.append(.homepage) }) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.leading, 16)
                .padding(.top, 16)
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
