//
//  Home.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 16.03.2022.
//

import SwiftUI

struct Home: View {
    
    @ObservedObject var taskModel: TaskViewModel = TaskViewModel()

    // Coredate Context
    @Environment(\.managedObjectContext) var context
    
    // Edit Button Context
    @Environment(\.editMode) var editMode

    @State var cardShow = false
        
    // Selected Day
    @State var selectedDay: Date = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                appThemeColor
                    .opacity(0.30)
                    .edgesIgnoringSafeArea(.top)
                
                VStack(spacing: 0) {
                    Section {
                        ZStack {
                            Color(.white)
                                .cornerRadius(30, corners: [.topLeft, .topRight])
                                .shadow(radius: 2)
                                .edgesIgnoringSafeArea(.bottom)
                            
                            ScrollView(showsIndicators: false) {
                                VStack{
                                    TaskView(selectedDay: $selectedDay)
                                        .environmentObject(taskModel)
                                }
                                .padding(.bottom, 150)
                            }
                        }
                   
                    } header: {
                        Header(cardShow: $cardShow, selectedDay: $selectedDay)
                            .environmentObject(taskModel)
                    }
                    .edgesIgnoringSafeArea(.bottom)

                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .overlay(
                    Button(action: {
                        taskModel.addNewTask.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .font(.system(size: 28))
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
                    NewTask(taskDate: selectedDay)
                        .environmentObject(taskModel)
                }
                
                BottomCard(cardShow: $cardShow, selectedDay: $selectedDay)
                    .environmentObject(taskModel)
                    .animation(.default)
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

    }
}

struct TaskView: View {
    @ObservedObject var taskModel: TaskViewModel = TaskViewModel()
    @Binding var selectedDay: Date

    var body: some View {
        LazyVStack {
            // Converting object as task model
            DynamicFilteredView(dateToFilter: selectedDay) { (object: Task) in
                
                TaskCardView(task: object, taskColor: Color(red: CGFloat(object.taskColor_R), green: CGFloat(object.taskColor_G), blue: CGFloat(object.taskColor_B), opacity: CGFloat(object.taskColor_A)))
                    .environmentObject(taskModel)
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
}


struct TaskCardView: View {
    //MARK: CoreData Context
    @Environment(\.managedObjectContext) var context
    
    var task: Task
    var taskColor: Color
    @ObservedObject var taskModel: TaskViewModel = TaskViewModel()
    var body: some View {
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
                let taskTimeRangeInt = task.taskEndTime?.rangeInt(from: task.taskStartTime ?? Date()) ?? 0
                
                let currentTime = task.taskEndTime?.rangeInt(from: Date()) ?? 0
//                ZStack(alignment: .top) {
//
//                    Capsule()
//                        .fill(taskColor)
//                        .frame(width: 65, height: 45)
//
//                    Capsule()
//                        .strokeBorder(.white, lineWidth: 3)
//                        .frame(width: 65, height: taskModel.getTaskHeight(taskTimeRange: taskTimeRangeInt))
//                        .shadow(radius: 5)
//
//                }
                
                ZStack {
                    Capsule()
                        .strokeBorder(.white, lineWidth: 5)
                        .frame(width: 65, height: taskModel.getTaskHeight(taskTimeRange: taskTimeRangeInt) + 10)
                        .shadow(radius: 5)
                    
                    ProgressCapsule(progress: taskModel.isToday(date: task.taskDate ?? Date()) ? (currentTime <= 0 ? CGFloat(1) : CGFloat( CGFloat((task.taskEndTime?.rangeInt(from: task.taskStartTime ?? Date()) ?? 0))/100 - CGFloat(currentTime)/100)) : CGFloat(0))
                        .fill(taskColor)
                        .frame(width: 55, height: taskModel.getTaskHeight(taskTimeRange: taskTimeRangeInt), alignment: .center)
                        .clipShape(Capsule())
                        .rotationEffect(.degrees(180))
                }
                                  
                VStack(alignment: .leading, spacing: 5) {
                    let taskStartTime = taskModel.extractDate(date: task.taskStartTime ?? Date(), format: "HH:mm")
                    let taskEndTime = taskModel.extractDate(date: task.taskEndTime ?? Date(), format: "HH:mm")
                    let taskTimeRange = task.taskEndTime?.range(from: task.taskStartTime ?? Date()) ?? ""
                    let remainderMin = task.taskEndTime?.rangeInt(from: Date()) ?? 0
                    
                    Text(taskModel.isCurrentHour(task: task) ? "\(remainderMin)min remaining" : taskStartTime == taskEndTime ? "\(taskStartTime)" : "\(taskStartTime)-\(taskEndTime) \("(\(taskTimeRange))")")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                            
                    ZStack {
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                            .foregroundColor(task.isCompleted ? .secondary : .black)
            
                        if task.isCompleted {
                            Rectangle()
                                .frame(height: 2, alignment: .center)
                        }
                    }
                    .fixedSize()
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
                                            .fill(Color(red: CGFloat(task.taskColor_R), green: CGFloat(task.taskColor_G), blue: CGFloat(task.taskColor_B), opacity: CGFloat(task.taskColor_A)))
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
}

struct Header: View {
    @ObservedObject var taskModel: TaskViewModel = TaskViewModel()
    @Binding var cardShow: Bool
    @Binding var selectedDay: Date

    var body: some View {
        VStack(spacing: 0) {
            HStack() {
               HeaderTop(cardShow: $cardShow, selectedDay: $selectedDay)
                    .environmentObject(taskModel)
            }
            .padding()

            HStack() {
                HeaderWeeks(selectedDay: $selectedDay)
                    .environmentObject(taskModel)
            }
            
        }
        .padding(.bottom)
    }
}

struct HeaderTop: View {
    @ObservedObject var taskModel: TaskViewModel = TaskViewModel()
    @Binding var cardShow: Bool
    @Binding var selectedDay: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack {
                    Text(taskModel.extractDate(date: selectedDay, format: "MMMM"))
                        .foregroundColor(.black)
                        .font(.title)
                        .bold()
                    
                    Text(taskModel.extractDate(date: selectedDay, format: "yyyy"))
                        .foregroundColor(.black)
                        .font(.title)
                        .bold()
                        
                }
                .hLeading()
                HStack(spacing: 20) {
                    Button {
                                           
                    } label: {
                        Image(systemName: "bolt.shield")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                    
                    
                    Button {
                        cardShow.toggle()
                    } label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                    
                    
                    Button {
                                           
                    } label: {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                            .foregroundColor(.black)

                    }
                    
                    Button {
                                           
                    } label: {
                        Image("ProfilePhoto")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .overlay(Circle()
                                        .stroke(.white, lineWidth: 2))
                            .shadow(radius: 10)
                    }
                }
                .hTrailing()
                
            }
        }
        .hLeading()
    }
}

struct HeaderWeeks: View {
    @ObservedObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    @Binding var selectedDay: Date

    var body: some View {
//                        Button {
//                            withAnimation {
//                                taskModel.weekCounter -= 1
//                                taskModel.fetchCurrentWeek()
//                                selectedDay = Calendar.current.date(byAdding: .day, value: -7, to: selectedDay)!
//                            }
//
//                        } label: {
//                            Image(systemName: "arrowtriangle.left.fill")
//                                .foregroundColor(.black)
//                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .center, spacing: 5) {
                                ForEach(taskModel.Week, id: \.self) { day in
                                    ZStack {
                                        Capsule()
                                            .fill(.white)
                                            .frame(width: 47, height: 90)
                                            .shadow(radius: 0.5)
                                        if taskModel.isSelectedDate(date: day, selectDay: selectedDay) {
                                            Capsule()
                                                .fill(taskModel.isToday(date: day) ? appThemeColor : .black)
                                                .frame(width: 42, height: 85)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                        
                                        VStack(spacing: 6) {
                                            
                                            Text(taskModel.extractDate(date: day, format: "EEE"))
                                                .font(.system(size: 15))
                                                .fontWeight(.semibold)
                                                .foregroundColor(taskModel.isSelectedDate(date: day, selectDay: selectedDay) ? .white : (taskModel.isToday(date: day) ? appThemeColor : .black))

                                            
                                            Text(taskModel.extractDate(date: day, format: "dd"))
                                                .font(.system(size: 15))
                                                .fontWeight(.semibold)
                                                .foregroundColor(taskModel.isSelectedDate(date: day, selectDay: selectedDay) ? .white : (taskModel.isToday(date: day) ? appThemeColor : .black))
                                       
                                        }
                                    
                                        DynamicFilteredCountView(dateToFilter: day) { (object: Task) in
                                            ZStack {
                                                Circle()
                                                    .fill(Color(red: CGFloat(object.taskColor_R), green: CGFloat(object.taskColor_G), blue: CGFloat(object.taskColor_B), opacity: CGFloat(object.taskColor_A)))
                                                    .opacity(object.isCompleted ? 0.5 : 1)
                                                    .frame(width: 13, height: 13)
                                                    .background(
                                                        Circle()
                                                            .strokeBorder(.white, lineWidth: 7)
                                                            .frame(width: 13, height: 13)
                                                    )
                                                Text(object.taskTitle?.prefix(1) ?? "")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 10))
                                                
                                            }
                                           
                                            }
                                        .offset(y: 29)
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            selectedDay = day
                                        }
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.size.width, alignment: .center)

                        }
                        .frame(width: UIScreen.main.bounds.size.width, alignment: .center)

        //                Button {
        //                    withAnimation {
        //                        taskModel.weekCounter += 1
        //                        taskModel.fetchCurrentWeek()
        //                        taskModel.selectedDay = Calendar.current.date(byAdding: .day, value: 7, to: taskModel.selectedDay)!
        //                    }
        //                } label: {
        //                    Image(systemName: "arrowtriangle.right.fill")
        //                        .foregroundColor(.black)
        //                }
    }
}



struct BottomCard: View {
    @ObservedObject var taskModel: TaskViewModel = TaskViewModel()
    @Binding var cardShow: Bool
    @Binding var selectedDay: Date

    var body: some View {
        ZStack {
            // background
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.5))
            .opacity(cardShow ? 1: 0)
            .animation(Animation.easeIn)
            .onTapGesture {
                cardShow.toggle()
            }
            
            //Card
            VStack {
                Spacer()
                VStack {
                    VStack(spacing: 5) {
                        DatePicker("", selection: $selectedDay, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                        
                        Button {
                            
                        } label: {
                            Text("Go To Selected Date")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .frame(width: UIScreen.main.bounds.width/1.3, height: 50)
                                .background(appThemeColor)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                    .padding()
                }
                .background(Color.white)
                .frame(height: UIScreen.main.bounds.height/2)
                .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                .shadow(color: cardShow ? .gray : .clear, radius: cardShow ? 1 : 0)
                .offset(y: cardShow ? 0 : UIScreen.main.bounds.height/2)
                .opacity(cardShow ? 1 : 0)
                .padding()
                .animation(.default)

            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ProgressCapsule: Shape {
    let progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let progressHeight = height * (1 - progress)
        
        path.move(to: CGPoint(x: 0, y: progressHeight))
        
        path.addLine(to: CGPoint(x: width, y: progressHeight))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: progressHeight))
        
        return path
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
