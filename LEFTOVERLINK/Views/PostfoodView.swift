//
//  PostfoodView.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 8/7/25.
//

import SwiftUI

struct PostfoodView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var postfoodVm = PostFoodViewModel()
    @State private var showMap = false;
   
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.1)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 1. Food Photo Picker
                    FoodPhotoPickerView(viewModel: postfoodVm.photoPickerVM)
                        .padding(.top, 30)
                    
                    // 2. Food Name
                    TextField("Food Name", text: $postfoodVm.foodName)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.white))
                                
                        )
                        
                    
                    // 3. Dietary Tag Dropdown
                    Picker("Dietary tag", selection: $postfoodVm.selectedDiet) {
                        ForEach(PostFoodViewModel.DietaryTag.allCases, id: \.self) { tag in
                            Text(tag.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // 4. Portion Selection (Stepper)
                    Stepper("Portion: \(postfoodVm.portion) people", value: $postfoodVm.portion, in: 1...100)
                    
                    // 5. Pickup Location
//                    TextField("Pickup Location", text: $postfoodVm.location)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 14)
//                        .background(
//                            RoundedRectangle(cornerRadius: 16)
//                                .fill(Color(.white))
//                                
//                        )
                    Button(action : {
                        showMap = true;
                    }) {
                        HStack{
                            Image(systemName: "location.fill")
                            Text("Pickup Location")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .bold(true)
                        }
                    }
                    .sheet(isPresented: $showMap) {
                       MapView(mapPurPose: .donationPickup, donationViewModel: postfoodVm)
                    }
                    
                    if !postfoodVm.locationdisplayName.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Pickup Location:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(postfoodVm.locationdisplayName)
                                .font(.body)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }

                    // 6. Submit Button
                    Button(action: {
                        postfoodVm.uploadFoodImageAndSavePost()
                        dismiss()
                    }) {
                        Text("Post for Donation")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(postfoodVm.formValid() ? Color.green : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("Donation post")
        }
    }
}


//#Preview {
//    NavigationStack{
//        PostfoodView()
//    }
//}
