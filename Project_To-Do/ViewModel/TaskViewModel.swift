//
//  TaskViewModel.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 19.03.2022.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    // Current Week Days
    @Published var currentWeek: [Date] = []
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
        
        let Week = calendar.dateInterval(of: .weekOfMonth, for: CWeek ?? Date())
        
        currentWeek.removeAll()
        (0...6).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: Week?.start ?? Date()) {
                currentWeek.append(weekday)
            }
        }
    }
    
    
    // Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // Checking if the current Date is Today
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
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
}

