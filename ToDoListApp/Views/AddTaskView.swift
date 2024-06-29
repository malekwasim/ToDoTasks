//
//  AddTaskView.swift
//  ToDoListApp
//
//  Created by Apple on 27/06/24.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: TaskViewModel
    @Binding var item: Task?
    @SwiftUI.Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var status: Status = .toDo
    @State private var showError = false
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)

                    Picker("Status", selection: $status) {
                        ForEach(Status.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Button(action: saveTask) {
                    Text("Save")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .clipShape(Capsule())
                .alert(isPresented: $showError) {
                    Alert(title: Text("Required"), message: Text("Please enter title."), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle(item == nil ? "Add Task" : "Edit Task")
            .onAppear(perform: loadTaskData)
        }
    }

    private func loadTaskData() {
        if let item = item {
            title = item.title ?? ""
            description = item.desc ?? ""
            status = Status(rawValue: item.status ?? "") ?? .toDo
        }
    }

    private func saveTask() {
        if title.isEmpty {
            showError = true
            return
        }
        viewModel.saveTask(item,
                           title: title,
                           desc: description,
                           status: status)
        dismiss()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
