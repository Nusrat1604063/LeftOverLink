//
//  RootView.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 18/7/25.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @EnvironmentObject var appState: Appstate
    @EnvironmentObject var model: Model

    @State private var isLoggedIn = Auth.auth().currentUser != nil

    var body: some View {
        Group {
            if isLoggedIn {
                HomePage()
            } else {
                Welcome()
            }
        }
        .onAppear {
            // Simple auth listener - update isLoggedIn when auth state changes
            Auth.auth().addStateDidChangeListener { _, user in
                isLoggedIn = (user != nil)
                // Add route clearing or other logic here if needed, carefully!
            }
        }
    }
}

