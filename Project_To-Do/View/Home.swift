//
//  Home.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 16.03.2022.
//

import SwiftUI
import Combine

class CustomTimer {
    let currentTimePublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
    let cancellable: AnyCancellable?
   
    init() {
        self.cancellable = currentTimePublisher.connect() as? AnyCancellable
    }

    deinit {
        self.cancellable?.cancel()
    }
}


// Start Timer
let timer = CustomTimer()


struct Home: View {
    
    @ObservedObject var taskModel: TaskViewModel = TaskViewModel()

    // Coredate Context
    @Environment(\.managedObjectContext) var context
    
    // Edit Button Context
   // @Environment(\.editMode) var editMode

    @State var calendarCardShow = false
    @State var taskCardShow = false

    // Selected Day
    @State var selectedDay: Date = Date()

    private var colorData = ColorData()

    var body: some View {
        NavigationView {
            ZStack {
                taskModel.appThemeColor
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
                                    TaskView(selectedDay: $selectedDay, taskCardShow: $taskCardShow)
                                        .environmentObject(taskModel)
                                }
                                .padding(.bottom, 150)
                            }
                        }
                   
                    } header: {
                        Header(calendarCardShow: $calendarCardShow, selectedDay: $selectedDay)
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
                            .background(taskModel.appThemeColor)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                        
                    })
                    .padding()
                    ,alignment: .bottomTrailing
                  
                )
                .sheet(isPresented: $taskModel.addNewTask) {
                    taskModel.editTask = nil
                } content: {
                    NewTask(taskDate: selectedDay, taskColor: taskModel.appThemeColor)
                        .environmentObject(taskModel)
                }
                
                BottomCardCalendar(calendarCardShow: $calendarCardShow, selectedDay: $selectedDay)
                    .environmentObject(taskModel)
                    .animation(.default)
                
//                BottomCardTask(cardShow: $taskCardShow)
//                    .environmentObject(taskModel)
//                    .animation(.default)
               
            }
            
        }
        .onAppear {
            taskModel.appThemeColor = colorData.loadColor()
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
    @EnvironmentObject var taskModel: TaskViewModel
    @Binding var selectedDay: Date
    @Binding var taskCardShow: Bool
    @State var currentTime: Date = Date()

    var body: some View {
        LazyVStack {
            // Converting object as task model
            DynamicFilteredView(dateToFilter: selectedDay) { (object: Task) in
                TaskCardView(taskCardShow: $taskCardShow, task: object, taskColor: Color(red: CGFloat(object.taskColor_R), green: CGFloat(object.taskColor_G), blue: CGFloat(object.taskColor_B), opacity: CGFloat(object.taskColor_A)), currentTime: self.currentTime)
                        .environmentObject(taskModel)
                        .hLeading()
                        .onReceive(timer.currentTimePublisher) { newCurrentTime in
                            self.currentTime = newCurrentTime
                        }
                        
            }
            
        }

    }
}


struct TaskCardView: View {
    @State private var waveOffset = Angle(degrees: 0)

    //MARK: CoreData Context
    @Environment(\.managedObjectContext) var context
    @Binding var taskCardShow: Bool
    var task: Task
    var taskColor: Color
    
    @ObservedObject var taskModel: TaskViewModel = TaskViewModel()

    var currentTime: Date
    
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
                let taskTimeRangeInt = task.taskEndTime?.rangeInt(from: task.taskStartTime ?? currentTime) ?? 0
                let taskHeight = taskModel.getTaskHeight(taskTimeRange: taskTimeRangeInt)
                let currentRange = currentTime.rangeInt(from: task.taskStartTime ?? currentTime)
                
                
                ZStack {
                    Capsule()
                        .strokeBorder(.white, lineWidth: 5)
                        .frame(width: 65, height: taskHeight)
                        .shadow(radius: 5)
                    
                    //ProgressCapsule(progress: taskModel.isToday(date: task.taskDate ?? Date()) ? (currentTime <= 0 ? CGFloat(1) : CGFloat( CGFloat((task.taskEndTime?.rangeInt(from: task.taskStartTime ?? Date()) ?? 0))/100 - CGFloat(currentTime)/100) ) : CGFloat(0))
                    
                    //Int(taskModel.convertRange(percent: remainderMin, maks: taskTimeRangeInt)
                    
                    //.fill(task.isCompleted ? .green : (taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .black : (taskModel.isCurrentHourAfterTaskTime(date: task.taskDate ?? Date()) ? .red : .clear)))
                    
                    Wave(offset: Angle(degrees: self.waveOffset.degrees), percent: taskModel.isCurrentHour(task: task) ? taskModel.convertRange(percent: currentRange, maks: taskTimeRangeInt) : (taskModel.isHourAfterTaskTime(task: task) ? 1.0 : 0.0))   // 0 capsule full fill, 1 capsule empty
                        .fill(Color(red: Double(task.taskColor_R), green: Double(task.taskColor_G), blue: Double(task.taskColor_B), opacity: Double(task.taskColor_A)))
                        .frame(width: 55, height: taskHeight-10)
                        .clipShape(Capsule())
                    
                }
               
                                  
                VStack(alignment: .leading, spacing: 5) {
                    let taskStartTime = taskModel.extractDate(date: task.taskStartTime ?? currentTime, format: "HH:mm")
                    let taskEndTime = taskModel.extractDate(date: task.taskEndTime ?? currentTime, format: "HH:mm")
                    let taskTimeRange = task.taskEndTime?.range(from: task.taskStartTime ?? currentTime) ?? ""
                    let remainderMin = task.taskEndTime?.rangeInt(from: currentTime) ?? 0
                    let checkCurrentHour = taskModel.isCurrentHour(task: task)
                    
                    Text(checkCurrentHour ? "\(remainderMin)min remaining" : taskStartTime == taskEndTime ? "\(taskStartTime)" : "\(taskStartTime)-\(taskEndTime) \("(\(taskTimeRange))")")
                        .font(checkCurrentHour ? .system(size: 13, weight: .bold) : .system(size: 13, weight: .medium))
                        .foregroundColor(checkCurrentHour ? .black : .secondary)
                            
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
        .padding([.leading,.trailing], 15)
    }
    
}

struct Header: View {
    @EnvironmentObject var taskModel: TaskViewModel
    @Binding var calendarCardShow: Bool
    @Binding var selectedDay: Date

    var body: some View {
        VStack(spacing: 0) {
            HStack() {
               HeaderTop(calendarCardShow: $calendarCardShow, selectedDay: $selectedDay)
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
    @EnvironmentObject var taskModel: TaskViewModel
    @Binding var calendarCardShow: Bool
    @Binding var selectedDay: Date
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
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
                HStack(spacing: 12) {
                    Button {
                                           
                    } label: {
                        Image(systemName: "bolt.shield")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                    
                    
                    Button {
                        calendarCardShow.toggle()
                    } label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                    }
                    
                    NavigationLink(destination: Settings().environmentObject(taskModel)) {
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
    @EnvironmentObject var taskModel: TaskViewModel
    @Namespace var animation
    @Binding var selectedDay: Date
    
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
 
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 5) {
//                    Button {
//                        withAnimation {
//                            taskModel.weekCounter -= 1
//                            taskModel.fetchCurrentWeek()
//                            selectedDay = Calendar.current.date(byAdding: .day, value: -7, to: selectedDay)!
//                        }
//
//                    } label: {
//                        Image(systemName: "arrowtriangle.left.fill")
//                            .foregroundColor(.black)
//                    }
                    
                    ForEach(taskModel.Week, id: \.self) { day in
                        ZStack {
                            Capsule()
                                .fill(.white)
                                .frame(width: 47, height: 90)
                                .shadow(radius: 0.5)
                            if taskModel.isSelectedDate(date: day, selectDay: selectedDay) {
                                Capsule()
                                    .fill(taskModel.isToday(date: day) ? taskModel.appThemeColor : .black)
                                    .frame(width: 42, height: 85)
                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                            }
                            
                            VStack(spacing: 6) {
                                
                                Text(taskModel.extractDate(date: day, format: "EEE"))
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(taskModel.isSelectedDate(date: day, selectDay: selectedDay) ? .white : (taskModel.isToday(date: day) ? taskModel.appThemeColor : .black))

                                
                                Text(taskModel.extractDate(date: day, format: "dd"))
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(taskModel.isSelectedDate(date: day, selectDay: selectedDay) ? .white : (taskModel.isToday(date: day) ? taskModel.appThemeColor : .black))
                           
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
                    
//                    Button {
//                        withAnimation {
//                            taskModel.weekCounter += 1
//                            taskModel.fetchCurrentWeek()
//                            selectedDay = Calendar.current.date(byAdding: .day, value: 7, to: selectedDay)!
//                        }
//                    } label: {
//                        Image(systemName: "arrowtriangle.right.fill")
//                            .foregroundColor(.black)
//                    }
                }
                .frame(width: UIScreen.main.bounds.size.width, alignment: .center)

            }
            .frame(width: UIScreen.main.bounds.size.width, alignment: .center)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { (value, gestureState, transaction) in
                        let delta = value.location.x - value.startLocation.x
                        if delta > 10 { // << some appropriate horizontal threshold here
                            gestureState = delta
                        }
                    }
                    .onEnded {
                        if $0.translation.width > 100 {
                            // Go to the previous slide
                            print("a")
                        }
                    }
            )
            
       
        
                     
   
    }
}



struct BottomCardCalendar: View {
    @EnvironmentObject var taskModel: TaskViewModel
    @Binding var calendarCardShow: Bool
    @Binding var selectedDay: Date

    var body: some View {
        ZStack {
            // background
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.5))
            .opacity(calendarCardShow ? 1: 0)
            .animation(Animation.easeIn)
            .onTapGesture {
                calendarCardShow.toggle()
            }
            
            //Card
            VStack {
                Spacer()
                VStack {
                    
                    VStack(spacing: 5) {
                        DatePicker("", selection: $selectedDay, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .accentColor(taskModel.appThemeColor)
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                .shadow(color: calendarCardShow ? .gray : .clear, radius: calendarCardShow ? 1 : 0)
                .frame(height: UIScreen.main.bounds.height/2)
                .offset(y: calendarCardShow ? 0 : UIScreen.main.bounds.height/2)
                .opacity(calendarCardShow ? 1 : 0)
                .padding()
                .animation(.default)

            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


//struct BottomCardTask: View {
//    @ObservedObject var taskModel: TaskViewModel = TaskViewModel()
//    @Binding var cardShow: Bool
//    // Coredate Context
//    @Environment(\.managedObjectContext) var context
//
//    var body: some View {
//        ZStack {
//            // background
//            GeometryReader { _ in
//                EmptyView()
//            }
//            .background(Color.gray.opacity(0.5))
//            .opacity(cardShow ? 1: 0)
//            .animation(Animation.easeIn)
//            .onTapGesture {
//                cardShow.toggle()
//            }
//
//            //Card
//            VStack {
//                Spacer()
//                VStack {
//                    VStack(alignment: .leading, spacing: 25) {
//                        VStack(spacing: 10) {
//                            HStack(spacing : 10) {
//                                Button {
//                                    taskModel.editTask = selectedTask
//                                    taskModel.addNewTask.toggle()
//
//                                } label: {
//                                    HStack {
//                                        Spacer()
//                                        Image(systemName: "square.and.pencil")
//                                            .font(Font.body.weight(.medium))
//                                            .padding(.vertical, 20)
//                                            .foregroundColor(.white)
//                                        Text("Edit")
//                                            .font(Font.body.weight(.medium))
//                                            .padding(.vertical, 20)
//                                            .foregroundColor(.white)
//                                        Spacer()
//                                    }.background(appThemeColor).cornerRadius(12)
//                                }
//
//
//                                Button {
//                                    withAnimation {
//                                        // Deleting Task
//                                        context.delete(selectedTask)
//                                        //Saving
//                                        try? context.save()
//                                    }
//                                } label: {
//                                    HStack {
//                                        Spacer()
//                                        Image(systemName: "trash")
//                                            .font(Font.body.weight(.medium))
//                                            .padding(.vertical, 20)
//                                            .foregroundColor(.white)
//                                        Text("Delete")
//                                            .font(Font.body.weight(.medium))
//                                            .padding(.vertical, 20)
//                                            .foregroundColor(.white)
//                                        Spacer()
//                                    }.background(appThemeColor).cornerRadius(12)
//                                }
//                            }
//                        }
//
//                    }
//                    .padding()
//                }
//                .background(Color.white)
//                .frame(height: UIScreen.main.bounds.height/2)
//                .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
//                .shadow(color: cardShow ? .gray : .clear, radius: cardShow ? 1 : 0)
//                .offset(y: cardShow ? 0 : UIScreen.main.bounds.height/2)
//                .opacity(cardShow ? 1 : 0)
//                .padding()
//                .animation(.default)
//
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}

struct Wave: Shape {

    var offset: Angle
    var percent: Double
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let waveHeight = percent == 0.0 || percent == 1.0 ? CGFloat(0.0) : CGFloat(3.0)
        let yoffset = CGFloat(percent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
