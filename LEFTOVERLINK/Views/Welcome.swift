//
//  Welcome.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 29/6/25.
//

import SwiftUI

struct Welcome: View {
    
    @EnvironmentObject private var appState : Appstate
    @EnvironmentObject private var model: Model
    var body: some View {
       
            ZStack{
                //            LinearGradient(
                //                gradient: Gradient(colors: [Color.green.opacity(0.5), Color.blue.opacity(0.2)]),
                //                startPoint: .topLeading,
                //                endPoint: .bottomTrailing
                //            )
                Color(red: 0.9, green: 1.0, blue: 0.9) // Soft mint green
                
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    ZStack{
                        Circle()
                            .fill(Color.white)
                            .frame(width: 160, height: 160)
                        Image("l5")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2) // Optional white ring
                            )
                    }
                    Text("LEFTOVERLINK")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .italic()
                        .foregroundColor(.green)
                        .padding(.top, 25)
                    
                    Text("Feed a soul, Change a day")
                        .font(.title)
                        .foregroundColor(Color(red: 0, green: 100/255, blue: 0)) // dark green
                        .bold()
                        .italic()
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    VStack{
                    
                        Button(action: {
                            appState.routes = [.signup]
                        }) {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.green))
                                .cornerRadius(12)
                        }
                        .padding(.top, 20)
                        HStack{
                            Text("Already have an account?")
                                .foregroundColor(.gray)
                            Button(action: {
                                appState.routes = [.login]
                                print("Login tapped")
                            }) {
                                Text("Login")
                                    .foregroundColor(Color(.green)) // Same dark red
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    
                }
                .padding()
                
            }
        }
    
}

#Preview {
    Welcome()
        .environmentObject(Appstate())
        .environmentObject(Model())
}
