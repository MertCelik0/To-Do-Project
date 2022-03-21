//
//  NewTask.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 19.03.2022.
//

import SwiftUI

struct NewTask: View {

  //  @Environment(\.dismiss) var dismiss
    
    //MARK: Task Values
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var taskDate: Date = Date()
    @State var date = Date()

    //MARK: CoreData Context
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskModel: TaskViewModel

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Go to work", text: $taskTitle) {
                        UIApplication.shared.endEditing()
                    }
                    .onAppear {
                        if let task = taskModel.editTask {
                            taskTitle = task.taskTitle ?? ""
                        }
                    }
                } header: {
                    Text("Task Title")
                }
                
                Section {
                    TextField("Nothing", text: $taskDescription) {
                        UIApplication.shared.endEditing()
                    }
                    .onAppear {
                        if let task = taskModel.editTask {
                            taskDescription = task.taskDescription ?? ""
                        }
                    }
                } header: {
                    Text("Task Description")
                }
                
                if taskModel.editTask == nil {
                    Section {
                        DatePicker("", selection: $taskDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                          
                    } header: {
                        Text("Task Date")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            //MARK: Disabling Dismiss on Swipe
            //MARK: Action Buttons
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let task = taskModel.editTask {
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                        }
                        else {
                            let task = Task(context: context)
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                            task.taskDate = taskDate
                        }
                        
                        // Save
                        try? context.save()
                        // Dissmissing View
                        //dismiss()
                    }
                    .disabled(taskTitle == "" || taskDescription == "")
                }
                
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
            }
        }

    }
}

struct NewTask_Previews: PreviewProvider {
    static var previews: some View {
        NewTask()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
