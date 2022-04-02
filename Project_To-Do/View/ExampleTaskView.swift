//
//  exampleTaskView.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 2.04.2022.
//

import SwiftUI

struct ExampleTaskView: View {
    var taskColor: Color
  //  var task: Task
    var body: some View {
        ZStack {
            HStack {
                ZStack {
                    Capsule()
                        .strokeBorder(.white, lineWidth: 5)
                        .frame(width: 65, height: 120)
                        .shadow(radius: 5)
                    
                    Wave(offset: Angle(degrees: Angle(degrees: 0).degrees), percent: 0.5)
                        .fill(taskColor)
                        .frame(width: 55, height: 110)
                        .clipShape(Capsule())

                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("08:00-10:00(2h)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                            
                    ZStack {
                        Text("Go to workout!")
                            .font(.title2.bold())
                            .foregroundColor(.black)
                    }
                    .fixedSize()
                }
                VStack(alignment: .center) {
                    Circle()
                        .strokeBorder(taskColor, lineWidth: 2)
                        .frame(width: 24, height: 24)
                        .background(
                            ZStack {
                                Circle()
                                    .fill(taskColor)
                                    .frame(width: 24, height: 24)
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 10, height: 10, alignment: .center)
                                    .foregroundColor(.white)
                            }
                        )
                }
                .hTrailing()
            }
        }
        .padding()
    }
}

struct ExampleTaskView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleTaskView(taskColor: .red)
    }
}
