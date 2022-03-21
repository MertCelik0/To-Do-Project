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
    
    @State private var fetchCount = 0

    // Coredate Context
    @Environment(\.managedObjectContext) var context
    
    // Edit Button Context
    @Environment(\.editMode) var editMode

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                
                HeaderView()
                
                ZStack {
                    
                    Color(.white)
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .shadow(radius: 5)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    ScrollView {
                        
                        VStack {
                            TaskView(taskColor: Color(red: 66/255.0, green: 129/255.0, blue: 164/255.0))
                        }
                        .hLeading()
                    }
                    
                }
                
            }
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
                        }
                    }
                }, label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(red: 252/255.0, green: 215/255.0, blue: 87/255.0))
                        .clipShape(Circle())
                        .shadow(radius: 5)

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
                        .background(Color(red: 53/255.0, green: 205/255.0, blue: 128/255.0))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                    
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
    }
    // TaskView
    func TaskView(taskColor: Color) -> some View {
        
        LazyVStack {
            // Converting object as task model
            DynamicFilteredView(dateToFilter: taskModel.currentDay, fetchCount: $fetchCount) { (object: Task) in
                
                
                TaskCardView(task: object, taskColor: taskColor)
                    .hLeading()
                
//                if fetchCount == 1 {
//
//
//                }
//                else {
//                    Capsule()
//                        .fill(Color(red: 66/255.0, green: 129/255.0, blue: 164/255.0))
//                        .frame(width: 5, height: 50)
//                        .shadow(radius: 5)
//                        .offset(x: 45)
//                        .hLeading()
//                }

            }
        }
    }
    
    // Task Card View
    func TaskCardView(task: Task, taskColor: Color) -> some View {
        
        HStack(alignment: editMode?.wrappedValue == .active ? .center : .top, spacing: 10) {
            
            if editMode?.wrappedValue == .active {

                VStack(spacing: 10) {
                    
                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()) {
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
                            // Deleting Task
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
                
            }
            else {
                HStack {
                    Button {
                        //Updating Task
                        task.isCompleted.toggle()
                        //Saving
                        try? context.save()
                    } label: {
                        if !task.isCompleted {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(red: 255/255.0, green: 64/255.0, blue: 0/255.0))
                                .padding(10)
                                .background(
                                    Color(red: 255/255.0, green: 64/255.0, blue: 0/255.0)
                                )
                                .cornerRadius(10)
                        }
                        else {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(
                                    Color(red: 255/255.0, green: 64/255.0, blue: 0/255.0)
                                )
                                .cornerRadius(10)
                        }
                    }
                 
                    
                    Circle()
                        .fill(taskColor)
                        .frame(width: 65, height: 65)
                        .shadow(radius: 5)
                }
               
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(taskModel.extractDate(date: task.taskDate ?? Date(), format: "HH:ss"))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    VStack(alignment: .leading, spacing: 3) {
                            
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                            .foregroundColor(.black)
                            .strikethrough(task.isCompleted ? true:false,color:.black)

                            
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                            .foregroundColor(.black)
                            .strikethrough(task.isCompleted ? true:false,color:.black)
                        
                    }
                }
            
            }
        }
        .padding()
    }
    
    // HeaderView
    func HeaderView() -> some View {
    
        VStack(spacing: 10) {
            HStack() {
                VStack(alignment: .leading, spacing: 30) {
                    Button {
                                           
                    } label: {
                          Image(systemName: "sidebar.left")
                              .resizable()
                              .foregroundColor(.black)
                              .frame(width: 35, height: 25)
                    }
                    
                    
                    HStack {
                        Text(taskModel.extractDate(date: taskModel.currentDay, format: "MMMM"))
                            .foregroundColor(.black)
                            .font(.title2)
                            .bold()
                        
                        Text(taskModel.extractDate(date: taskModel.currentDay, format: "yyyy"))
                            .foregroundColor(Color(red: 255/255.0, green: 64/255.0, blue: 0/255.0))
                            .font(.title2)
                            .bold()
                            
                    }
                    
                }
                .hLeading()
                
                VStack (alignment: .leading, spacing: 10) {
                    Image("ProfilePhoto")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .hTrailing()
            }
            
            HStack {
                Button {
                    withAnimation {
                       
                        taskModel.weekCounter -= 1
                        taskModel.fetchCurrentWeek()
                        if taskModel.weekCounter == 0 {
                            taskModel.currentDay = Date()
                        }
                        else {
                            taskModel.currentDay = Calendar.current.date(byAdding: .day, value: taskModel.weekCounter*7, to: Date())!
                        }
                    }
                    
                } label: {
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(.black)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
       
                    HStack(spacing: 5) {
                        
                        ForEach(taskModel.currentWeek, id: \.self) { day in

                            VStack(spacing: 10) {
                                
                                Text(taskModel.extractDate(date: day, format: "EEE"))
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.secondary)
                                
                                
                                Text(taskModel.extractDate(date: day, format: "dd"))
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                    .background(
                                        ZStack {
                                         
                                            if taskModel.isToday(date: day) {
                                                Capsule()
                                                    .fill(Color(red: 255/255.0, green: 64/255.0, blue: 0/255.0))
                                                    .frame(width: 30, height: 30)
                                                    .shadow(radius: 3)
                                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                            }
                                            
                                        }
                                    )
                            }
                            .frame(width: 45, height: 90)
                            .onTapGesture {
                                withAnimation {
                                    taskModel.currentDay = day
                                }
                            }
                        }
                    }
                }
                
                Button {
                    withAnimation {
                        taskModel.weekCounter += 1
                        taskModel.fetchCurrentWeek()
                        if taskModel.weekCounter == 0 {
                            taskModel.currentDay = Date()
                        }
                        else {
                            taskModel.currentDay = Calendar.current.date(byAdding: .day, value: taskModel.weekCounter*7, to: Date())!
                        }
                    }
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                        .foregroundColor(.black)
                }
            }
           
        }
        .padding()

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
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
            clipShape( RoundedCorner(radius: radius, corners: corners) )
        }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
