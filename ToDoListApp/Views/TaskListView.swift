//
//  TaskListView.swift
//  ToDoListApp
//
//  Created by Apple on 27/06/24.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)])
    var items: FetchedResults<Task>
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingAddTask = false
    @State private var selectedTask: Task?
    @State private var selectedFilter: TaskStatusFilter = .all
    @State private var searchQuery = ""

    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(TaskStatusFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TextField("Search by title", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                List {
                    ForEach(filteredItems) { item in
                        Button(action: {
                            selectedTask = item
                            showingAddTask = true
                        }) {
                            TaskListRow(task: item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }

            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        Text("Logout")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedTask = nil
                        showingAddTask = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(viewModel: TaskViewModel(context: viewContext), item: $selectedTask)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private var filteredItems: [Task] {
        items.filter { item in
            let matchesFilter = {
                switch selectedFilter {
                case .all:
                    return true
                case .toDo:
                    return item.status == TaskStatusFilter.toDo.rawValue
                case .inProgress:
                    return item.status == TaskStatusFilter.inProgress.rawValue
                case .done:
                    return item.status == TaskStatusFilter.done.rawValue
                }
            }()

            let matchesSearchQuery = searchQuery.isEmpty || (item.title?.localizedCaseInsensitiveContains(searchQuery) ?? false)

            return matchesFilter && matchesSearchQuery
        }
    }

}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
