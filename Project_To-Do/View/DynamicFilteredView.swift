//
//  DynamicFilteredView.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 19.03.2022.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View,T>: View  where T: NSManagedObject {
    // Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    @Binding var fetchCount: Int

    // Building custom forEach which will give core data object to build view
    init(dateToFilter: Date, fetchCount: Binding<Int>, @ViewBuilder content: @escaping (T)->Content) {
        // Filter current date tasks
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: dateToFilter)
        let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        // Filter key
        let filterKey = "taskDate"
        
        // This will fetch task between today and tommorow whic is 24 hrs
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today,tommorow])
        
        // Intializing request qith nspredicate
        // adding sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.taskDate, ascending: true)], predicate: predicate)
        self.content = content
        self._fetchCount = fetchCount

    }
    
    var body: some View {
        Group {
            if request.isEmpty {
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
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
                .onReceive(request.publisher.count()) { _ in
                    fetchCount = request.count
                }
                
            }
        }
    }
}
