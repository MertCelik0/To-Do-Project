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
    @State var selectStartTime: Date = Date()
    @State var selectEndTime: Date = Date()
    @State var taskColor: Color = Color(red: 97/255.0, green: 152/255.0, blue: 142/255.0)
    @State var taskTimeRange: Int = 0
    @State var hoursSelectedIndex: Int = 0
    @State var beforeSelectedHour: Int = 0
    @State var timeArray: [Int] = [1, 15, 30, 45, 60, 90, 120]
    @State var filteredTimeArray: [Int] = []

    //MARK: CoreData Context
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskModel: TaskViewModel

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Section {
                        ScrollView {
                            VStack(spacing: 40) {
                                
                                VStack {
                                    Section {
                                        ColorView(selectionColor: $taskColor)
                                    }
                                }
                                
                                VStack {
                                    Section {
                                        HStack(spacing: 10) {
                                            Rectangle()
                                                .fill(.gray)
                                                .frame(width: 40, height: 40)
                                                .cornerRadius(10)
                                                .background(
                                                   RoundedRectangle(cornerRadius: 10)
                                                      .stroke(taskColor, lineWidth: 6)
                                                )
                                            
                                            CustomTextField(placeHolder: "Go to workout!", value: $taskTitle, lineColor: taskColor, width: 2)
                                            .onAppear {
                                                if let task = taskModel.editTask {
                                                    taskTitle = task.taskTitle ?? ""
                                                }
                                            }
                                        }
                                        .padding([.leading, .trailing], 20)
                                    } header: {
                                        HStack {
                                            Text("Task Title")
                                                .foregroundColor(.secondary)
                                                .font(.title2)
                                                .bold()
                                            Spacer()
                                        }
                                    }
                                    
                                }
                                VStack {
                                    Section {
                                        VStack {
                                            
                                            HStack {
                                                Text("Date")
                                                    .font(.title3)
                                                    .bold()
                                                Spacer()
                                                DatePicker("",
                                                    selection: $taskDate,
                                                    displayedComponents: .date
                                                 ).colorInvert().colorMultiply(taskColor)
                                                    .labelsHidden()
                                                    .environment(\.locale, Locale.init(identifier: "en_GB"))
                                                    
                                            }
                                            .onAppear(perform: {
                                                getCurrentTimeAndResetValues()
                                            })
                                            .onChange(of: taskDate) { newValue in
                                                getCurrentTimeAndResetValues()

                                            }
                                            
                                            HStack {
                                                Text("Start Time")
                                                    .font(.title3)
                                                    .bold()
                                                Spacer()
                                                DatePicker("", selection: $selectStartTime, in: Date.distantPast...Date.distantFuture, displayedComponents: .hourAndMinute )
                                                    .colorInvert().colorMultiply(taskColor)
                                                    .labelsHidden()
                                                    .environment(\.locale, Locale.init(identifier: "en_GB"))
                                                    .onChange(of: selectStartTime, perform: { newValue in
                                                        var array: [Int] = []
                                                        for time in timeArray {
                                                            if Calendar.current.isDate(taskDate, inSameDayAs: Calendar.current.date(byAdding: .minute, value: time, to: selectStartTime) ?? selectStartTime) {
                                                                array.append(time)
                                                            }
                                                        }
                                                        filteredTimeArray.removeAll()
                                                        for time in array {
                                                            filteredTimeArray.append(time)
                                                        }
                                                    })
                                            }
                                          
                                            HStack {
                                                Text("End Time")
                                                    .font(.title3)
                                                    .bold()
                                                Spacer()
                                                DatePicker("", selection: $selectEndTime, in: selectStartTime...Date.distantFuture, displayedComponents: .hourAndMinute)
                                                    .colorInvert().colorMultiply(taskColor)
                                                   .labelsHidden()
                                                   .environment(\.locale, Locale.init(identifier: "en_GB"))

                                            }
                                        }
                                        .padding([.leading, .trailing], 20)
                                      
                                    } header: {
                                        HStack {
                                            Text("Task Date")
                                                .foregroundColor(.secondary)
                                                .font(.title2)
                                                .bold()
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                }
                                
                                VStack {
                                    Section {
                                        VStack {
                                            SegmentView(taskTimeRange: $taskTimeRange, selectedIndex: $hoursSelectedIndex, options: filteredTimeArray, color: taskColor)
                                            .onChange(of: taskTimeRange) { _ in
                                                selectEndTime = Calendar.current.date(byAdding: .minute, value: -beforeSelectedHour, to: selectStartTime) ?? selectEndTime
                                                selectEndTime = Calendar.current.date(byAdding: .minute, value: taskTimeRange, to: selectStartTime) ?? selectEndTime
                                                
                                                beforeSelectedHour = taskTimeRange
                                            }
                                        }
                                    } header: {
                                        HStack {
                                            Text("Task Time")
                                                .foregroundColor(.secondary)
                                                .font(.title2)
                                                .bold()
                                            
                                            Spacer()
                                        }
                                    }
                                }

                                Spacer()
                            }
                            .padding()
                        }
                    } footer: {
                        
                        Button {
                            if let task = taskModel.editTask {
                                task.taskTitle = taskTitle
                            }
                            else {
                                let task = Task(context: context)
                                task.taskTitle = taskTitle
                                task.taskDate = taskModel.setStringtoDate(date: taskModel.setDatetoString(date: taskDate))
                                task.taskStartTime = selectStartTime
                                task.taskEndTime = selectEndTime
                                task.taskColor_R = Float(taskColor.components.red)
                                task.taskColor_G = Float(taskColor.components.green)
                                task.taskColor_B = Float(taskColor.components.blue)
                                task.taskColor_A = Float(taskColor.components.opacity)
                            }

                            // Save
                            try? context.save()
                            // Dissmissing View
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Create Task")
                                .foregroundColor(.white)
                                .font(.system(size: 25).bold())
                                .frame(width: UIScreen.main.bounds.width/1.3, height: 50)
                                .background(taskColor)
                                .cornerRadius(10)
                                .padding()
                        }
                        .disabled(taskTitle == "")
                    }
                    
                }
               
                }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("CREATE").font(.title).foregroundColor(.black).bold()
                        Text("TASK").font(.title).foregroundColor(taskColor).bold()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
//                .toolbar {
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
                    
                   

 //               }
                
            }
           
        }
        

    }
    
    func getCurrentTimeAndResetValues() {
        let hour = Calendar.current.component(.hour, from: Date())
        let minutes = Calendar.current.component(.minute, from: Date())
        let sec = Calendar.current.component(.second, from: Date())
        
        selectStartTime = Calendar.current.date(bySettingHour: hour, minute: minutes, second: sec, of: taskDate)!
        selectEndTime = Calendar.current.date(bySettingHour: hour, minute: minutes, second: sec, of: taskDate)!
        filteredTimeArray = timeArray
        hoursSelectedIndex = 0
        beforeSelectedHour = 0
        
        var array: [Int] = []
        for time in timeArray {
            if Calendar.current.isDate(taskDate, inSameDayAs: Calendar.current.date(byAdding: .minute, value: time, to: selectStartTime) ?? selectStartTime) {
                array.append(time)
            }
        }
        filteredTimeArray.removeAll()
        for time in array {
            filteredTimeArray.append(time)
        }
    
    }
}


