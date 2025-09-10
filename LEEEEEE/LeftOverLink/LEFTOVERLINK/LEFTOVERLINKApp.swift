//
//  LEFTOVERLINKApp.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 29/6/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct LEFTOVERLINKApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = Appstate()
    @StateObject private var model = Model()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.routes) {
                ZStack {
                    if Auth.auth().currentUser != nil {
                        HomePage() // ✅ Show a real view when logged in
                    } else {
                        Welcome()
                    }
                }
                // ✅ 👇 This must be INSIDE NavigationStack, but OUTSIDE ZStack
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .signup: SignUp()
                    case .login: LogIn()
                    case .profile: Profile()
                    case .feedaStray: FeedStrayView()
                    case .donationpost: PostfoodView()
                    case .welcome: Welcome()
                    case .homepage: HomePage()
                    }
                }
            }
            .environmentObject(appState)
            .environmentObject(model)
        }
    }
}
