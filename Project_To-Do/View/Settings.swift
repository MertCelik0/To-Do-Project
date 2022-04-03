//
//  Settings.swift
//  Project_To-Do
//
//  Created by Mert Celik on 31.03.2022.
//

import SwiftUI

struct Settings: View {
    //  @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var taskModel: TaskViewModel
    @State var openTheme: Bool = false
    var body: some View {
        List {
            Section {
                Button {
                    openTheme.toggle()
                } label: {
                    Text("Theme")
                        .foregroundColor(.black)
                }
            } header: {
            }
            .sheet(isPresented: $openTheme) {
                
            } content: {
                Theme()
                    .environmentObject(taskModel)
            }
            
            Section {
                NavigationLink(destination: Contributors()) {
                    Text("Contributors")
                        .foregroundColor(.black)
                }
            } header: {
            }
        }.listStyle(InsetGroupedListStyle())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Text("Settings").font(.title).foregroundColor(taskModel.appThemeColor).bold()
                }
            }
        }
    }
}
