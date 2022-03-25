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
    // Selected Day
    @Published var selectedDay: Date = Date()
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
        (1...7).forEach { day in
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
    func isSelectedDate(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(selectedDay, inSameDayAs: date)
    }
    
    // Checking if the current Date is Today
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(Date(), inSameDayAs: date)
    }
    
    // Checking if the currentHour is task hour
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currenthour = calendar.component(.hour, from: Date())
        
        let isToday = calendar.isDateInToday(date)
        
        return (hour == currenthour && isToday)
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
//    func getTaskHeight(taskHour: Int) -> CGFloat {
//        var value: Float = 0
//
//        let Hour = Int(taskHour)!
//
//        if Hour == 0 {
//            if Minute >= 0 && Minute >= 15 {
//                value = 0.10
//            }
//            else if Minute >= 16 && Minute >= 30 {
//                value = 0.25
//            }
//            else if Minute >= 31 && Minute >= 45 {
//                value = 0.40
//            }
//            else if Minute >= 46 && Minute >= 60 {
//                value = 0.55
//            }
//        }
//        else if Hour == 1 {
//            if Minute >= 0 && Minute >= 30 {
//                value = 1.15
//           }
//            else if Minute >= 31 && Minute >= 60 {
//                value = 1.45
//           }
//        }
//        else{
//            value = 2
//        }
//
//        return CGFloat(65 * (1.0 + value))
//    }
}

