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
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = Appstate()
    @StateObject private var model = Model()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.routes) {
                ZStack {
                  
                    if Auth.auth().currentUser != nil {
                        Welcome()
                    } else {
                        Profile()
                    }
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                    case .signup:
                        SignUp()
                    case .login:
                        LogIn()
                    case .profile:
                        Profile()
                    case .welcome:
                        Welcome()
                    }
                }
            }.environmentObject(appState)
             .environmentObject(model)
        }
    }
}
