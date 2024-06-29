//
//  LoginView.swift
//  ToDoListApp
//
//  Created by Apple on 28/06/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isPasswordVisible = false
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $isLoginMode, label: Text("Picker here")) {
                    Text("Login").tag(true)
                    Text("Register").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                ZStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button(action: handleAction) {
                        Text(isLoginMode ? "Login" : "Register")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                }

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
        }
    }

    private func handleAction() {
        isLoading = true
        if isLoginMode {
            login()
        } else {
            register()
        }
    }

    private func login() {
        authViewModel.login(email: email,
                            password: password) { error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
            } else {
                self.showError = false
            }
        }
    }

    private func register() {
        authViewModel.register(email: email,
                               password: password) { error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
            } else {
                self.showError = false
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}


