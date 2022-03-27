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

        print("\(startTime) + \(endTime)")

        if startTime <= now && endTime >= now {
            return true
        } else {
            return false
        }
    }
    
    // Check is the current time after the task time?
    func isCurrentHourAfterTaskTime(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currenthour = calendar.component(.hour, from: Date())
        return currenthour >= hour
    }
    
    func getHoursAndMinutes(hour: Int, min: Int) -> String {
        var components = DateComponents()
        components.hour = hour
        components.minute = min
        let date = Calendar.current.date(from: components)
        
        return extractDate(date: date ?? Date(), format: "HH:mm")
    }
    func getHours(hour: Int) -> String {
        var components = DateComponents()
        components.hour = hour
        let date = Calendar.current.date(from: components)
        
        return extractDate(date: date ?? Date(), format: "HH")
    }
    
    func getMinutes(min: Int) -> String {
        var components = DateComponents()
        components.minute = min
        let date = Calendar.current.date(from: components)
        
        return extractDate(date: date ?? Date(), format: "mm")
    }
    
    func getMinuteForData(selectedMin: Int) -> Int {
        var minData: Int = 0
        if selectedMin <= 14 {
            minData = 11
        }
        else {
            minData = 3
        }
        return minData
    }
    
    func getMinutemultiplyData(selectedMin: Int) -> Int {
        var multiplyData: Int = 0
        if selectedMin <= 14 {
            multiplyData = 5
        }
        else {
            multiplyData = 15
        }
        return multiplyData
    }
    
    
    // Get task height
    func getTaskHeight(taskTimeRange: Int) -> CGFloat {
        var taskTime = taskTimeRange
        var value: Float = 0

        if taskTime >= 200 {
            taskTime = 200
        }
        
        value = Float(taskTime) / 100
        return CGFloat(65 * (1+value))
    }
}

