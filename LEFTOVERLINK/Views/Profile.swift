//
//  Profile.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 30/6/25.
//

import SwiftUI

struct Profile: View {
    @State private var fullName = ""
    
    var body: some View {
        ZStack {
            Color(.systemYellow)
                .opacity(0.2)
                .ignoresSafeArea()
            VStack(spacing : 8) {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.7))
                        .frame(width: 200, height: 200)
                        .shadow(radius: 10)
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 100)
            
                }
                .padding(.top, 40)
                Text("Samia Ibtesum")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
                HStack(alignment: .center) {
                    Text("Bio :")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                   Text("I love sharing food and reducing waste")
                        .foregroundColor(.black)
                        .font(.headline)
                           
                    
                     
                }
                HStack(alignment: .center) {
                    Image(systemName:"mappin.and.ellipse")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                   Text("Dhanmondi, 13")
                        .foregroundColor(.black)
                        .font(.title2)
                           
                    
                     
                }
                Spacer()
                
              
                                
            }
            .padding(.top, 40)
          
            
        }
    }
}

#Preview {
    Profile()
}
