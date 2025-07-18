//
//  LogIn.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 30/6/25.
//

import SwiftUI
import FirebaseAuth

struct LogIn: View {
    @State private var email = ""
    @State private var password = ""
    
    @EnvironmentObject private var appState: Appstate
    @EnvironmentObject private var model: Model
    
    private var isFormvalid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    private func login() async  {
        do {
          let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("✅ Logged in as user: \(result.user.uid)")
            appState.routes.append(.profile)
            
        } catch {
            print("❌ Login failed: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
      
            
            ZStack {
                Color.yellow.opacity(0.2)
                    .ignoresSafeArea()
                VStack(spacing: 25) {
                   Group {
                       TextField("Email", text: $email)
                           .keyboardType(.emailAddress)
                           .autocapitalization(.none)
                          
                       SecureField("Password", text: $password)
                    }
                   .padding()
                   .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                   .cornerRadius(10)
                   .padding(.horizontal)
                    
                    Button(action: {
                        _ = Task {
                            await login()
                        }
                       
                        print("Tapped login")
                    }) {
                        Text("LogIn")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.green)
                            .cornerRadius(12)
                            .padding()
                    }
                }
            }
           
        } 
    
}

//#Preview {
//    NavigationStack{
//        LogIn()
//            .environmentObject(Model())
//            .environmentObject(Appstate())
//    }
//}
