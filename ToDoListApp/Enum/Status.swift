//
//  Status.swift
//  ToDoListApp
//
//  Created by Apple on 27/06/24.
//

import Foundation
enum Status: String, CaseIterable {
    case toDo = "To Do"
    case inProgress = "In Progress"
    case done = "Done"

    var name: String{
        return rawValue
    }
}
