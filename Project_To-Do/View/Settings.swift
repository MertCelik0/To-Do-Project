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
    @State var taskColor: Color = Color(red: 97/255.0, green: 152/255.0, blue: 142/255.0)

    var body: some View {
        NavigationView {
            List {
                 Text("Theme")
                 Text("Hello World")
                 Text("Hello World")
             }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("Settings").font(.title).foregroundColor(appThemeColor).bold()
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

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
