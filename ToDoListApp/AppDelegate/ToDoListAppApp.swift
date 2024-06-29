//
//  ToDoListAppApp.swift
//  ToDoListApp
//
//  Created by Apple on 27/06/24.
//

import SwiftUI
import FirebaseAuth

@main
struct ToDoListAppApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            //If user is authenticate show Task List else show Login 
            if authViewModel.isAuthenticated {
                TaskListView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
            
        }
    }
}
