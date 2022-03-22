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
    
    // Week Days Task Count
    @State  var fetchCount: Int = 0

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
//            // Edit button
//            .overlay(
//                Button(action: {
//                    if editMode?.wrappedValue == .active {
//                        withAnimation { () -> () in
//                            editMode?.wrappedValue = .inactive
//                        }
//                    }
//                    else {
//                        withAnimation { () -> () in
//                            editMode?.wrappedValue = .active
//                        }
//                    }
//                }, label: {
//                    Image(systemName: "pencil")
//                        .foregroundColor(.black)
//                        .padding()
//                        .background(Color(red: 252/255.0, green: 215/255.0, blue: 87/255.0))
//                        .clipShape(Circle())
//                        .shadow(radius: 5)
//
//                })
//                .padding()
//                .offset(y: -60)
//                ,alignment: .bottomTrailing
//
//            )

            // Add button
            .overlay(
                Button(action: {
                    taskModel.addNewTask.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                        .background(appThemeColor)
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
            DynamicFilteredView(dateToFilter: taskModel.selectedDay) { (object: Task) in
                
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
        
        HStack(alignment: .top, spacing: 10) {
            
//           if editMode?.wrappedValue == .active {

//                VStack(spacing: 10) {
//
//                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()) {
//                        Button {
//                            taskModel.editTask = task
//                            taskModel.addNewTask.toggle()
//                        } label: {
//                            Image(systemName: "pencil.circle.fill")
//                                .font(.title)
//                                .foregroundColor(.primary)
//                        }
//                    }
//
//                    Button {
//                        withAnimation {
//                            // Deleting Task
//                            context.delete(task)
//                            //Saving
//                            try? context.save()
//                        }
//                    } label: {
//                        Image(systemName: "minus.circle.fill")
//                            .font(.title)
//                            .foregroundColor(.red)
//                    }
//
//                }
//
//            }
//            else {
//            }
            
         
            HStack {
                VStack(alignment: .center) {
                    Circle()
                        .fill(taskColor)
                        .frame(width: 65, height: 65)
                        .shadow(radius: 5)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(taskModel.extractDate(date: task.taskDate ?? Date(), format: "HH:ss"))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                            
                    Text(task.taskTitle ?? "")
                        .font(.body.bold())
                        .foregroundColor(task.isCompleted ? .secondary : .black)
                        .strikethrough(task.isCompleted ? true : false, color: task.isCompleted ? .secondary : .black)
                }
                
                VStack(alignment: .center) {
                    Button {
                        withAnimation {
                            //Updating Task
                            task.isCompleted.toggle()
                            //Saving
                            try? context.save()
                        }
                    } label: {
                        if !task.isCompleted {
                            Circle()
                                .strokeBorder(taskColor, lineWidth: 2)
                                .frame(width: 24, height: 24)
                         
                        }
                        else {
                            Circle()
                                .strokeBorder(taskColor, lineWidth: 2)
                                .frame(width: 24, height: 24)
                                .background(
                                    ZStack {
                                        Circle()
                                            .fill(taskColor)
                                            .frame(width: 24, height: 24)
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .frame(width: 10, height: 10, alignment: .center)
                                            .foregroundColor(.white)
                                    }
                                )
                        }
                    }
                }
                .hTrailing()
            }
        }
        .padding()
    }
    
    // HeaderView
    func HeaderView() -> some View {
    
        VStack(spacing: 10) {
            HStack() {
                VStack(alignment: .leading, spacing: 30) {
                    
                    HStack {
                        HStack {
                            Button {
                                                   
                            } label: {
                                Image("ProfilePhoto")
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                            }
                        }
                        .hLeading()
                        HStack {
                            Button {
                                                   
                            } label: {
                                Image(systemName: "shield.fill")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(appThemeColor)
                            }
                            
                            Button {
                                                   
                            } label: {
                                Image(systemName: "gear")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle())
                                    .foregroundColor(appThemeColor)

                            }
                        }
                        .hTrailing()
                        
                    }
                    
                    HStack {
                        Text(taskModel.extractDate(date: taskModel.selectedDay, format: "MMMM"))
                            .foregroundColor(.black)
                            .font(.title)
                            .bold()
                        
                        Text(taskModel.extractDate(date: taskModel.selectedDay, format: "yyyy"))
                            .foregroundColor(appThemeColor)
                            .font(.title)
                            .bold()
                            
                    }
                    
                }
                .hLeading()
                
  
            }
            
            HStack {
                Button {
                    withAnimation {
                        taskModel.weekCounter -= 1
                        taskModel.fetchCurrentWeek()
                        taskModel.selectedDay = Calendar.current.date(byAdding: .day, value: -7, to: taskModel.selectedDay)!
                    }
                    
                } label: {
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(.black)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
       
                    HStack(alignment: .center, spacing: 4) {
                        ForEach(taskModel.Week, id: \.self) { day in
                            
                            VStack(spacing: 10) {
                                
                                Text(taskModel.extractDate(date: day, format: "EEE"))
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.secondary)
                                
                                
                                Text(taskModel.extractDate(date: day, format: "dd"))
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(taskModel.isSelectedDate(date: day) ? .white : (taskModel.isToday(date: day) ? .red : .black))
                                    .background(
                                        VStack {
                                            ZStack {
                                                VStack {
                                                    if taskModel.isSelectedDate(date: day) {
                                                        Capsule()
                                                            .fill(appThemeColor)
                                                            .frame(width: 30, height: 30)
                                                            .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                                    }
                                                }
                                                    
                                                DynamicFilteredCountView(dateToFilter: day) { (object: Task) in
                                                    ZStack {
                                                        Circle()
                                                            .fill(Color(red: 66/255.0, green: 129/255.0, blue: 164/255.0))
                                                            .opacity(object.isCompleted ? 0.5 : 1)
                                                            .frame(width: 15, height: 15)
                                                            .background(
                                                                Circle()
                                                                    .strokeBorder(.white, lineWidth: 5)
                                                                    .frame(width: 15, height: 15)
                                                            )
                                                        Text(object.taskTitle?.prefix(1) ?? "")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 10))
                                                        
                                                    }
                                                   
                                                    }
                                                .offset(y: 25)
                                            }
                                        }
                                    )
                            }
                            .padding(.bottom)
                            .frame(width: 45, height: 90)
                            .onTapGesture {
                                withAnimation {
                                    taskModel.selectedDay = day
                                }
                            }
                        }
                    }
                    
                }
                
                Button {
                    withAnimation {
                        taskModel.weekCounter += 1
                        taskModel.fetchCurrentWeek()
                        taskModel.selectedDay = Calendar.current.date(byAdding: .day, value: 7, to: taskModel.selectedDay)!
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
