//
//  SignUp.swift
//  LEFTOVERLINK
//
//  Created by Tabassum Akter Nusrat on 29/6/25.
//

import SwiftUI
import FirebaseAuth

struct SignUp: View {
    @State private var name  = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    
    
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var appstate: Appstate
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && password == confirmPassword
    }
    
    
    //create Brand New user in Firebase
    
    private func signUp() async  {
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await model.updateDisplayName(for: result.user, dsiplayName: name)
            appstate.routes.append(Route.login)
            
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.yellow).opacity(0.2)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Create an Account")
                        .font(.title)
                        .bold()
                        .foregroundColor(.green)
                    
                    Spacer().frame(height: 40)
                    
                    Group {
                        TextField("Name", text: $name)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                    .padding()
                    .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Button(action: {
                        
                        Task{
                            await signUp()
                        }
                        print("Signing up with: \(email)")
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.green)) // Very light green
                            .cornerRadius(12)
                    }.disabled(!isFormValid)
                        .padding(.horizontal, 40)
                    
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Button(action: {
                            appstate.routes.append(.login)
                            print("Login tapped")
                        }) {
                            Text("Login")
                                .foregroundColor(Color(red: 139/255, green: 0, blue: 0))
                                .bold()
                        }
                    }
                    Text(errorMessage)
                    
                    
                }
                 // 💡 This shows as a navigation bar title
                .navigationBarTitleDisplayMode(.inline) // or .large
            }
        }
    }
}

#Preview {
    SignUp()
        .environmentObject(Model())  //injection
        .environmentObject(Appstate())
}
