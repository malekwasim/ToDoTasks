//
//  TaskViewModel.swift
//  ToDoListApp
//
//  Created by Apple on 27/06/24.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func addItem(title: String, description: String, status: Status) {
        let newItem = Task(context: viewContext)
        newItem.title = title
        newItem.desc = description
        newItem.status = status.rawValue
        newItem.date = Date()
        saveContext()
    }
    func saveTask(_ task: Task?,
                  title: String,
                  desc: String,
                  status: Status) {
        if let task = task {
            // Edit existing task
            task.title = title
            task.desc = desc
            task.status = status.name
            task.date = Date()
        } else {
            // Add new task
            addItem(title: title, description: desc, status: status)
        }
        saveContext()
    }

    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}