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
    // Select Week
    @Published var weekCounter: Int = 0
    
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
        
        if startTime <= now && endTime >= now {
            return true
        } else {
            return false
        }
    }
    
    // Get task height
    func getTaskHeight(taskTimeRange: Int) -> CGFloat {
        var taskTime = taskTimeRange

        if taskTime >= 100 {
            taskTime = 100
            return 65 * (1 + CGFloat(100) / 100)
        }
        else {
            return 65 * (1 + CGFloat(taskTime) / 100)
        }
        
    }
    
    func convertRange(taskRange: Int) -> Int {
        var range: Int = 0
                
        if taskRange >= 100 {
            range = 100
        } else {
            range = taskRange
        }
//
        let findvalue = 100 - range
        
        let taskPrecent = range
   
        print(taskPrecent)
        
        if taskPrecent >= 100 {
            return 0
        }
        else if taskPrecent >= 90 && taskPrecent <= 99 {
            return 10
        }
        else if taskPrecent >= 80 && taskPrecent <= 89 {
            return 20
        }
        else if taskPrecent >= 70 && taskPrecent <= 79 {
            return 30
        }
        else if taskPrecent >= 60 && taskPrecent <= 69 {
            return 40
        }
        else if taskPrecent >= 50 && taskPrecent <= 59 {
            return 50
        }
        else if taskPrecent >= 40 && taskPrecent <= 49 {
            return 60
        }
        else if taskPrecent >= 30 && taskPrecent <= 39 {
            return 70
        }
        else if taskPrecent >= 20 && taskPrecent <= 29 {
            return 80
        }
        else if taskPrecent >= 10 && taskPrecent <= 19 {
            return 90
        }
        else if taskPrecent >= 1 && taskPrecent <= 9 {
            return 95
        }
        else if taskPrecent <= 0 {
            return 100
        }
        else {
            return 0
        }
    }
}

