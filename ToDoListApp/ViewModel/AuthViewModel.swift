//
//  AuthViewModel.swift
//  ToDoListApp
//
//  Created by Apple on 28/06/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false

    init() {
        self.isAuthenticated = Auth.auth().currentUser != nil
    }

    func login(email: String,
               password: String,
               completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                self.isAuthenticated = true
                completion(nil)
            }
        }
    }

    func register(email: String,
                  password: String,
                  completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                self.isAuthenticated = true
                completion(nil)
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
