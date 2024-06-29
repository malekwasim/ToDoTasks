//
//  TaskListRow.swift
//  ToDoListApp
//
//  Created by Apple on 28/06/24.
//

import SwiftUI

struct TaskListRow: View {
    var task: Task
    var body: some View {
        VStack(alignment: .leading) {
            Text(task.title ?? "Untitled")
                .font(.headline)
            Text(task.desc ?? "No Description")
                .font(.subheadline)
            Text(task.status ?? "Unknown")
                .font(.caption)
        }
    }
}

#Preview {
    TaskListRow(task: Task())
}
