//
//  DynamicFilteredView.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 19.03.2022.
//

import SwiftUI
import CoreData


struct DynamicFilteredView<Content: View>: View {
    let fetchRequest: FetchRequest<Task>
    let content: (Task) -> Content

    init(dateToFilter: Date, @ViewBuilder content: @escaping (Task) -> Content) {
        guard let entityName = Task.entity().name else { fatalError("Unknown entity") }

        // Filter current date tasks
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: dateToFilter)
        let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        // Filter key
        let filterKey = "taskDate"
        
        // This will fetch task between today and tommorow whic is 24 hrs
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today,tommorow])
        
        let request = NSFetchRequest<Task>(entityName: entityName)
        request.sortDescriptors = [.init(keyPath: \Task.taskStartTime, ascending: true)]
        request.predicate = predicate

        self.init(fetchRequest: request, content: content)
    }

    init(fetchRequest: NSFetchRequest<Task>, @ViewBuilder content: @escaping (Task) -> Content) {
        self.fetchRequest = FetchRequest<Task>(fetchRequest: fetchRequest)
        self.content = content
    }
    
    var body: some View {
        Group {
            if fetchRequest.wrappedValue.isEmpty {
                VStack {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .offset(y: 100)
                    Text("No tasks Found!")
                        .font(.system(size: 26))
                        .fontWeight(.semibold)
                        .offset(y: 100)
                }
            }
            else {
                VStack {
                    ForEach(fetchRequest.wrappedValue, id: \.objectID) { object in
                        self.content(object)
                    }
                }
            }
        }
        
    }
}

struct DynamicFilteredCountView<Content: View>: View {
    let fetchRequest: FetchRequest<Task>
    let content: (Task) -> Content

    init(dateToFilter: Date, @ViewBuilder content: @escaping (Task) -> Content) {
        guard let entityName = Task.entity().name else { fatalError("Unknown entity") }

        // Filter current date tasks
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: dateToFilter)
        let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
                
        // Filter key
        let filterKey = "taskDate"
        
        // This will fetch task between today and tommorow whic is 24 hrs
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today,tommorow])
        
        let request = NSFetchRequest<Task>(entityName: entityName)
        request.sortDescriptors = [.init(keyPath: \Task.taskStartTime, ascending: true)]
        request.predicate = predicate

        self.init(fetchRequest: request, content: content)
    }

    init(fetchRequest: NSFetchRequest<Task>, @ViewBuilder content: @escaping (Task) -> Content) {
        self.fetchRequest = FetchRequest<Task>(fetchRequest: fetchRequest)
        self.content = content
    }
    
    var body: some View {
        Group {
            if fetchRequest.wrappedValue.isEmpty {
            }
            else {
                HStack(spacing: -6) {
                    // fetchRequest.wrappedValue[0...2] max 3 value
                    if fetchRequest.wrappedValue.count >= 4 {
                        ForEach(fetchRequest.wrappedValue[0...3] , id: \.objectID) { object in
                            self.content(object)
                        }
                    }
                    else {
                        ForEach(fetchRequest.wrappedValue , id: \.objectID) { object in
                            self.content(object)
                        }
                    }
                    
                }
                
                
            }
        }
    }
    
}

