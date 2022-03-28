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
                              
                              
                                
//                                if taskModel.editTask == nil {
//                                    VStack(spacing: 10) {
//                                        HStack {
//                                            Text("When?")
//                                                .foregroundColor(.secondary)
//                                                .font(.title2)
//                                                .bold()
//
//                                            Spacer()
//                                        }
//                                        LazyVStack {
//
//                                            HStack(spacing: 0) {
//                                                ZStack {
//                                                    RoundedRectangle(cornerRadius: 5)
//                                                        .frame(width: UIScreen.main.bounds.width/1.4, height: 32)
//                                                        .foregroundColor(appThemeColor)
//
//                                                    Picker("", selection: $selectedTime) {
//                                                        ForEach((0...23), id: \.self) { hour in
//                                                            ForEach((0...taskModel.getMinuteForData(selectedMin: selectedMinute)), id: \.self) { min in
//                                                                if selectedMinute != 1 {
//
//                                                                    Text("\(taskModel.getHoursAndMinutes(hour: hour, min: min * taskModel.getMinutemultiplyData(selectedMin: selectedMinute))) - \(taskModel.getHoursAndMinutes(hour: hour, min: (min * taskModel.getMinutemultiplyData(selectedMin: selectedMinute)) + selectedMinute))")
//
//                                                                }
//                                                                else {
//                                                                    Text(taskModel.getHoursAndMinutes(hour: hour, min: min * 5))
//                                                                }
//
//                                                            }
//                                                         }
//                                                    }
//                                                    .pickerStyle(.wheel)
//                                                    .frame(width: UIScreen.main.bounds.width/1.4)
//
//                                                }
//                                            }
//
//                                        }
//
//
//                                    }
//                                }
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
                                            .onChange(of: taskDate) { newValue in
                                                selectStartTime = taskDate
                                                selectEndTime = taskDate
                                                hoursSelectedIndex = 0
                                                beforeSelectedHour = 0
                                            }
                                            
                                            HStack {
                                                Text("Start Time")
                                                    .font(.title3)
                                                    .bold()
                                                Spacer()
                                                DatePicker("", selection: $selectStartTime, displayedComponents: .hourAndMinute ).colorInvert().colorMultiply(taskColor)
                                                    .labelsHidden()
                                                    .environment(\.locale, Locale.init(identifier: "en_GB"))
                                            }
                                          
                                            HStack {
                                                Text("End Time")
                                                    .font(.title3)
                                                    .bold()
                                                Spacer()
                                                DatePicker("", selection: $selectEndTime, in: selectStartTime..., displayedComponents: .hourAndMinute).colorInvert().colorMultiply(taskColor)
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
                                            SegmentView(taskTimeRange: $taskTimeRange, selectedIndex: $hoursSelectedIndex, options: [1, 15, 30, 45, 60, 90], color: taskColor)
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
                              
                                VStack {
                                    Section {
                                        ColorView(selectionColor: $taskColor)
                                    } header: {
                                        HStack {
                                            Text("Task Color")
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
                        Text("TASK").font(.title).foregroundColor(taskColor).bold()
                        Text("CREATE").font(.title).foregroundColor(.black).bold()
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
}


