//
//  Theme.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 2.04.2022.
//

import SwiftUI

struct Theme: View {
    //  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode

    //MARK: CoreData Context
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskModel: TaskViewModel
    
    
    private var colorData = ColorData()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack {
                        ExampleTaskView(taskColor: taskModel.appThemeColor)
                    }
                } header: {
                    
                }
                
                Section {
                    VStack {
                        ColorView(selectionColor: $taskModel.appThemeColor)
                            .onChange(of: taskModel.appThemeColor) { newValue in
                                colorData.saveColor(color: taskModel.appThemeColor)
                            }
                    }
                } header: {
                    HStack {
                        Text("App Color")
                            .foregroundColor(.secondary)
                            .font(.body)
                            .bold()
                        Spacer()
                    }
                }
                
//                Section {
//                    HStack {
//                        Spacer()
//                        VStack(spacing: 0) {
//                            RoundedRectangle(cornerRadius: 15)
//                                .fill(
//                                    LinearGradient(
//                                        gradient: Gradient(stops: [
//                                            Gradient.Stop(color: .white, location: 0.5),
//                                            Gradient.Stop(color: .black, location: 0.5)
//                                        ]),
//                                        startPoint: .topLeading,
//                                        endPoint: .bottomTrailing))
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke(Color.secondary, lineWidth: 1)
//                                )
//                                .frame(width: 100, height: 40)
//                            
//                            Text("System")
//                        }
//                        VStack(spacing: 0) {
//                            RoundedRectangle(cornerRadius: 15)
//                                .fill(Color.white)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke(Color.secondary, lineWidth: 1)
//                                )
//                                .frame(width: 100, height: 40)
//                            
//                            Text("Light")
//                        }
//                        VStack(spacing: 0) {
//                            RoundedRectangle(cornerRadius: 15)
//                                .fill(Color.black)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .stroke(Color.secondary, lineWidth: 1)
//
//                                )
//                                .frame(width: 100, height: 40)
//                            
//                            Text("Dark")
//                        }
//                        Spacer()
//                    }
//                } header: {
//                    HStack {
//                        Text("Background Color")
//                            .foregroundColor(.secondary)
//                            .font(.body)
//                            .bold()
//                        Spacer()
//                    }
//                }
                
                Section {
                    VStack {
                        
                    }
                } header: {
                    HStack {
                        Text("App Icon")
                            .foregroundColor(.secondary)
                            .font(.body)
                            .bold()
                        Spacer()
                    }
                }
                
            }.listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("Theme").font(.title).foregroundColor(taskModel.appThemeColor).bold()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                
            }
        }
    }
}
