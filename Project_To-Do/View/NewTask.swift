//
//  NewTask.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 19.03.2022.
//

import SwiftUI

struct NewTask: View {

  //  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

    //MARK: Task Values
    @State var taskTitle: String = ""
    @State var taskDate: Date = Date()
    @State var selectedTime: Int = 0
    @State var date = Date()
    
    @State var selectedMinute: Int = 14

    //MARK: CoreData Context
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskModel: TaskViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color(.white)
                    
                VStack {
                   
                    Section {
                        ScrollView {
                            VStack(spacing: 40) {
                                
                                Section {
                                    HStack(spacing: 10) {
                                        Rectangle()
                                            .frame(width: 40, height: 40)
                                        
                                        TextField("Go to work", text: $taskTitle) {
                                            UIApplication.shared.endEditing()
                                        }
                                        .font(.system(size: 24).bold())
                                        .onAppear {
                                            if let task = taskModel.editTask {
                                                taskTitle = task.taskTitle ?? ""
                                            }
                                        }
                                    }
                                }
                                
                                if taskModel.editTask == nil {
                                    VStack(spacing: 10) {
                                        HStack {
                                            Text("When?")
                                                .foregroundColor(.secondary)
                                                .font(.title2)
                                                .bold()
                                            
                                            Spacer()
                                        }
                                        LazyVStack {
                                          
                                            HStack(spacing: 0) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .frame(width: UIScreen.main.bounds.width/1.4, height: 32)
                                                        .foregroundColor(appThemeColor)
                                                    
                                                    Picker("", selection: $selectedTime) {
                                                        ForEach((0...23), id: \.self) { hour in
                                                            ForEach((0...taskModel.getMinuteForData(selectedMin: selectedMinute)), id: \.self) { min in
                                                                if selectedMinute != 1 {
                                                                    
                                                                    Text(selectedTime == hour ? "\(taskModel.getHoursAndMinutes(hour: hour, min: min * taskModel.getMinutemultiplyData(selectedMin: selectedMinute))) - \(taskModel.getHoursAndMinutes(hour: hour, min: (min * taskModel.getMinutemultiplyData(selectedMin: selectedMinute)) + selectedMinute))" : "\(taskModel.getHoursAndMinutes(hour: hour, min: min * taskModel.getMinutemultiplyData(selectedMin: selectedMinute)))")
                                                                        .onAppear(perform: {
                                                                            print(selectedTime)
                                                                        })
                                                            
                                                                }
                                                                else {
                                                                    Text(taskModel.getHoursAndMinutes(hour: hour, min: min * 5))
                                                                }
                                                                
                                                            }
                                                         }
                                                    }
                                                    
                                                    .pickerStyle(.wheel)
                                                    .frame(width: UIScreen.main.bounds.width/1.4)
                                                }
                                            }

                                        }

                                    }
                                }
                                
                                VStack(spacing: 10) {
                                    HStack {
                                        Text("How much will it take?")
                                            .foregroundColor(.secondary)
                                            .font(.title2)
                                            .bold()
                                        
                                        Spacer()
                                    }
                                }
                                
                                VStack(spacing: 10) {
                                    HStack {
                                        Text("What color?")
                                            .foregroundColor(.secondary)
                                            .font(.title2)
                                            .bold()
                                        
                                        Spacer()
                                    }
                                }

                                
                                Spacer()
                            }
                            .padding()
                        }
                    } footer: {
                        Button {
                            
                        } label: {
                            Text("Create Task")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .frame(width: UIScreen.main.bounds.width/1.3, height: 50)
                                .background(appThemeColor)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("Save") {
//                            if let task = taskModel.editTask {
//                                task.taskTitle = taskTitle
//                            }
//                            else {
//                                let task = Task(context: context)
//                                task.taskTitle = taskTitle
//                                task.taskDate = taskDate
//                            }
//
//                            // Save
//                            try? context.save()
//                            // Dissmissing View
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                        .disabled(taskTitle == "")
//                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }

                }
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
