//
//  Contributors.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 2.04.2022.
//

import SwiftUI

struct Contributors: View {
    //  @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State var taskColor: Color = Color(red: 97/255.0, green: 152/255.0, blue: 142/255.0)
    var body: some View {
        NavigationView {
            List {
                Section {
                    
                } header: {
                    
                }
                
            }.listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("Contributors").font(.title).foregroundColor(.black).bold()
                    }
                }
            }
        }
    }
}

struct Contributors_Previews: PreviewProvider {
    static var previews: some View {
        Contributors()
    }
}
