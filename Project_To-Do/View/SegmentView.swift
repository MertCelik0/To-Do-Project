//
//  SegmentView.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 26.03.2022.
//

import SwiftUI

struct SegmentView: View {
    
    @Binding var taskTimeRange: Int
    @Binding var selectedIndex: Int
    var options: [Int]
    var color: Color
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.2))
                    Rectangle()
                        .fill(color)
                        .cornerRadius(10)
                        .padding(4)
                        .opacity(selectedIndex == index ? 1 : 0.01)
                        .onTapGesture {
                                withAnimation(.interactiveSpring()) {
                                    taskTimeRange = options[index]
                                    selectedIndex = index
                                }
                            }
                        
                }
                .overlay(
                    Text(selectedIndex == index ? (getIntToStringValue(Value: options[index]).suffix(2) != "hr" ? getIntToStringValue(Value: options[index])+"m" : getIntToStringValue(Value: options[index])) : getIntToStringValue(Value: options[index]))
                        .foregroundColor(selectedIndex == index ? .white : .secondary)
                        .font(selectedIndex == index ? .system(size: 18).bold() : .system(size: 18))
                )
            }
        }
        .frame(height: 50)
        .cornerRadius(10)
    }
    
    func getIntToStringValue(Value: Int) -> String {
        switch Value {
        case 1:
            return "1"
        case 15:
            return "15"
        case 30:
            return "30"
        case 45:
            return "45"
        case 60:
            return "1hr"
        case 90:
            return "1,5hr"
        default:
            return ""
        }
        
    }
}
