//
//  PostfoodView.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 8/7/25.
//

import SwiftUI

struct PostfoodView: View {
    
    enum DietaryTag: String, CaseIterable {
        case halal
        case vegan
        case meat
    }
    
    @StateObject private var photoPickerVM = photoPickerViewModel()
    
    // Form state variables
    @State private var selectedDiet: DietaryTag = .halal
    @State private var foodName: String = ""
    @State private var portion: Int = 1
    @State private var location: String = ""
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.1)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 1. Food Photo Picker
                    FoodPhotoPickerView(viewModel: photoPickerVM)
                        .padding(.top, 30)
                    
                    // 2. Food Name
                    TextField("Food Name", text: $foodName)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.white))
                                
                        )
                        
                    
                    // 3. Dietary Tag Dropdown
                    Picker("Dietary tag", selection: $selectedDiet) {
                        ForEach(DietaryTag.allCases, id: \.self) { tag in
                            Text(tag.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // 4. Portion Selection (Stepper)
                    Stepper("Portion: \(portion) people", value: $portion, in: 1...100)
                    
                    // 5. Pickup Location
                    TextField("Pickup Location", text: $location)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.white))
                                
                        )
                    // 6. Submit Button
                    Button(action: {
                        // Submit logic goes here
                    }) {
                        Text("Post Food")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("Post Food")
        }
    }
}


#Preview {
    PostfoodView()
}
