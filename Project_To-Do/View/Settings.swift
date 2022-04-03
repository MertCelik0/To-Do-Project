//
//  Settings.swift
//  Project_To-Do
//
//  Created by Mert Celik on 31.03.2022.
//

import SwiftUI

struct Settings: View {
    //  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var taskModel: TaskViewModel

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: Theme().environmentObject(taskModel)) {
                        Text("Theme")
                            .foregroundColor(.black)
                    }
                } header: {
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
