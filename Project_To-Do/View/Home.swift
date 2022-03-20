//
//  Home.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 16.03.2022.
//

import SwiftUI

struct Home: View {
    
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    // Coredate Context
    @Environment(\.managedObjectContext) var context
    
    // Edit Button Context
    @Environment(\.editMode) var editMode

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    
                    TaskView()
                    
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        
        // Edit button
        .overlay(
            Button(action: {
                if editMode?.wrappedValue == .active {
                    withAnimation { () -> () in
                        editMode?.wrappedValue = .inactive
                    }
                }
                else {
                    withAnimation { () -> () in
                        editMode?.wrappedValue = .active
                    }                }
            }, label: {
                Image(systemName: "pencil")
                    .foregroundColor(.black)
                    .padding()
                    .background(Color(red: 255/255.0, green: 209/255.0, blue: 102/255.0),in: Circle())
            })
            .padding()
            .offset(y: -60)
            ,alignment: .bottomTrailing
            
        )

        // Add button
        .overlay(
            Button(action: {
                taskModel.addNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(.black)
                    .padding()
                    .background(Color(red: 6/255.0, green: 214/255.0, blue: 160/255.0),in: Circle())
            })
            .padding()
            ,alignment: .bottomTrailing
          
        )
        .sheet(isPresented: $taskModel.addNewTask) {
            taskModel.editTask = nil
        } content: {
            NewTask()
                .environmentObject(taskModel)
        }

    }
    // TaskView
    func TaskView() -> some View {
        LazyVStack(spacing: 20) {
            // Converting object as task model
            DynamicFilteredView(dateToFilter: taskModel.currentDay) { (object: Task) in
                TaskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
    }
    
    // Task Card View
    func TaskCardView(task: Task) -> some View {
        // since core data values will give optinal data
        HStack(alignment: editMode?.wrappedValue == .active ? .center : .top, spacing: 30) {
            
            
            if editMode?.wrappedValue == .active {
                // Edit Button for current and future tasks
                VStack(spacing: 10) {
                    
                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()){
                        Button {
                            taskModel.editTask = task
                            taskModel.addNewTask.toggle()
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            //MARK: Deleting Task
                            context.delete(task)
                            //Saving
                            try? context.save()
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    
                }
            } else {
                VStack(spacing: 10) {
                    Circle()
                        .fill(task.isCompleted ? .green : (taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .black : (taskModel.isCurrentHourAfterTaskTime(date: task.taskDate ?? Date()) ? .red : .clear)))
                        .frame(width: 15, height: 15)
                        .background(
                            Circle()
                                .stroke(.black, lineWidth: 1)
                                .padding(-3)
                        )
                        .scaleEffect(!taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0.8 : 1)
                    
                    Capsule()
                        .stroke(.black, lineWidth: 1)
                        .frame(width: 5)
                }
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
                        
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                            .foregroundStyle(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
                    }
                    .hLeading()
                    
                    Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                        .foregroundStyle(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
                }
                if taskModel.isCurrentHour(date: task.taskDate ?? Date()) {
                    HStack(spacing: 12) {
                        //Check button
                        if !task.isCompleted {
                            Button {
                                //MARK: Updating Task
                                task.isCompleted = true
                                //Saving
                                try? context.save()
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.black)
                                    .padding(10)
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        Text(task.isCompleted ? "Marked as Completed" : "Mark Task as Completed")
                            .font(.system(size: task.isCompleted ? 14 : 16, weight: .bold))
                            .foregroundColor(task.isCompleted ? .green : .white)
                            .hLeading()
                    }
                    .padding(.top)
                }
            }
            .padding(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0 : 10)
            .hLeading()
            .background(
                Color(red: 38/255.0, green: 84/255.0, blue: 124/255.0)
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
            )
        }
        .hLeading()
    }
    
    // HeaderView
    func HeaderView() -> some View {
        VStack(spacing: 10){
            HStack {
                VStack(alignment: .leading, spacing: 30) {
                    Button {
                        
                    } label: {
                        Image(systemName: "sidebar.left")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 35, height: 25)
                    }
                    
                    HStack (spacing: 5) {
                        Text(taskModel.extractDate(date: taskModel.currentDay, format: "MMMM"))
                            .foregroundColor(.black)
                            .bold()
                            .font(.title)
                        
                        Text(taskModel.extractDate(date: taskModel.currentDay, format: "yyyy"))
                            .foregroundColor(Color(red: 38/255.0, green: 84/255.0, blue: 124/255.0))
                            .bold()
                            .font(.title)
                    }
                }
                .hLeading()
                
                VStack (alignment: .leading, spacing: 10) {
                    Image("ProfilePhoto")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                    Spacer()
                }
            }
            
            HStack {
                // Current Week View
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(taskModel.currentWeek, id: \.self) { day in
                            VStack(spacing: 10) {
                                // EEE will return day as MON, TUE...
                                Text(taskModel.extractDate(date: day, format: "EEE"))
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                    .foregroundColor(.black)
                                
                                Text(taskModel.extractDate(date: day, format: "dd"))
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                    .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                    .background(
                                        ZStack {
                                            // Metched Geometry Effect
                                            if taskModel.isToday(date: day) {
                                                Capsule()
                                                    .fill(Color(red: 38/255.0, green: 84/255.0, blue: 124/255.0))
                                                    .frame(width: 50, height: 30)
                                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                            }
                                        }
                                    )
                            }
                            // Shape
                            .frame(width: 45, height: 90)
                            .onTapGesture {
                                withAnimation {
                                    taskModel.currentDay = day
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//MARK: UI Design helper functions
extension View {
    func hLeading() -> some View { self
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View { self
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View { self
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    //MARK: Safe Area
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}
