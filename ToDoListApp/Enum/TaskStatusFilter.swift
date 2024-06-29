//
//  TaskStatusFilter.swift
//  ToDoListApp
//
//  Created by Apple on 28/06/24.
//

import Foundation
enum TaskStatusFilter: String, CaseIterable {
    case all = "All"
    case toDo = "To Do"
    case inProgress = "In Progress"
    case done = "Done"

    var name: String {
        return rawValue
    }
}
