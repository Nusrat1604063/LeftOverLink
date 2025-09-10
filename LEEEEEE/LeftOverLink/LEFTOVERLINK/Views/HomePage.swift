//
//  HomePage.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 15/7/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HomePage: View {
    @EnvironmentObject private var appstate: Appstate
    @StateObject private var viewModel = DonationPostViewModel()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                
                // Scrollable Feed Section
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.posts) { post in
                        DonationPostCardView(post: post)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Styled Tab Bar
                HStack {
                    Spacer()
                    
                    Button {
                        appstate.routes.append(.profile)
                    } label: {
                        VStack {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                            
                        }
                    }
                    Spacer()
                    
                    Button {
                        appstate.routes.append(.feedaStray)
                    } label: {
                        VStack {
                            Image(systemName: "pawprint")
                            Text("Feed a Stray")
                        }
                    }
                    Spacer()
                    
                    Button {
                        try? Auth.auth().signOut()
                        appstate.routes.append(.welcome)
                    } label: {
                        VStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                    }
                    
                    Spacer()
                }
                .frame(height: 80)
                .background(Color(UIColor.systemGray6))
            }
            .onAppear {
                viewModel.listenToPosts()
            }
            
            // Floating "Donation Post" button
            // ✅ Floating "Donation Post" button using appState.routes
            Button {
                appstate.routes.append(.donationpost)
            } label: {
                Text("Donation Post")
                    .font(.caption)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .shadow(radius: 4)
            }
            .padding(.top, 16)
            .padding(.trailing, 16)
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
}
//
//#Preview {
//    NavigationStack(path: .constant(NavigationPath())) {
//            HomePage()
//                .environmentObject(Appstate())
//                .navigationDestination(for: Route.self) { route in
//                    switch route {
//                    case .profile: Text("Profile")
//                    case .feedaStray: Text("Feed a Stray")
//                    case .donationpost: Text("Donation")
//                    case .welcome: Text("Welcome")
//                    default: EmptyView()
//                    }
//                }
//        }
//}
