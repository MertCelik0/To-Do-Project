//
//  TaskViewModel.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 19.03.2022.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    // Current Week Days
    @Published var Week: [Date] = []
    // Current Day
    @Published var currentDay: Date = Date()
    // New Task View
    @Published var addNewTask: Bool = false
    // Edit Task View
    @Published var editTask: Task?
    // Settings View
    @Published var settingsTask: Bool = false
    // Settings View
    @Published var themeTask: Bool = false
    // Select Week
    @Published var weekCounter: Int = 0
    
    @Published var appThemeColor: Color = Color(red: 123.0/255, green: 166.0/255, blue: 255.0/255, opacity: 255.0/255)

    
    // Intializing
    init() {
        fetchCurrentWeek()
    }
    
    // get current week
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current

        let CWeek = calendar.date(byAdding: .weekOfMonth, value: weekCounter, to: today)
        
        let selectedWeek = calendar.dateInterval(of: .weekOfMonth, for: CWeek ?? Date())
        
        Week.removeAll()
        (0...6).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: selectedWeek?.start ?? Date()) {
                Week.append(weekday)
            }
        }
    }
    // Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func setStringtoDate(date: String) -> Date{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date) ?? Date()
    }

    func setDatetoString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // Checking if the selected date
    func isSelectedDate(date: Date, selectDay: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(selectDay, inSameDayAs: date)
    }
    
    // Checking if the current Date is Today
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(Date(), inSameDayAs: date)
    }
    
    // Checking if the currentHour is task hour
    func isCurrentHour(task: Task) -> Bool {
        let calendar = Calendar.current
        
        let starthour = calendar.component(.hour, from: task.taskStartTime ?? Date())
        let startmin = calendar.component(.minute, from: task.taskStartTime ?? Date())

        let endhour = calendar.component(.hour, from: task.taskEndTime ?? Date())
        let endmin = calendar.component(.minute, from: task.taskEndTime ?? Date())

        let startTimeComponent = DateComponents(calendar: calendar, hour: starthour, minute: startmin)
        let endTimeComponent   = DateComponents(calendar: calendar, hour: endhour, minute: endmin)

        let now = Date()
        let startTime = calendar.date(byAdding: startTimeComponent, to: task.taskDate ?? Date())!
        let endTime = calendar.date(byAdding: endTimeComponent, to: task.taskDate ?? Date())!
        
        return startTime <= now && endTime >= now
    }
    
    // Check is the current time after the task time?
    func isHourAfterTaskTime(task: Task) -> Bool {
        let calendar = Calendar.current
        
        let starthour = calendar.component(.hour, from: task.taskStartTime ?? Date())
        let startmin = calendar.component(.minute, from: task.taskStartTime ?? Date())

        let startTimeComponent = DateComponents(calendar: calendar, hour: starthour, minute: startmin)

        let now = Date()
        let startTime = calendar.date(byAdding: startTimeComponent, to: task.taskDate ?? Date())!
        
        return startTime >= now
    }
    
    // Get task height
    func getTaskHeight(taskTimeRange: Int) -> CGFloat {
        var taskTime = taskTimeRange

        if taskTimeRange >= 100 {
            taskTime = 100
            return 65 * (1 + CGFloat(taskTime) / 100)
        }
        else if taskTimeRange >= 0 && taskTimeRange <= 99 {
            taskTime = taskTimeRange
            return 65 * (1 + CGFloat(taskTime) / 100)
        }
        else {
            return 65
        }
    }
    
    func convertRange(percent: Int, maks: Int) -> Double {
        let taskPrecent = (Double(percent) / Double(maks))
        return 1 - taskPrecent
    }
}

