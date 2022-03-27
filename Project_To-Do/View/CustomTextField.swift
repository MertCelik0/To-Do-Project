//
//  CustomTextField.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 26.03.2022.
//

import SwiftUI

struct CustomTextField: View {
    var placeHolder: String
    @Binding var value: String
    
    var lineColor: Color
    var width: CGFloat
    
    var body: some View {
        VStack {
            TextField(self.placeHolder, text: $value) {
                UIApplication.shared.endEditing()
            }
            .font(.system(size: 24).bold())
            
            Rectangle().frame(height: self.width)
                .padding(.leading, 0)
                .foregroundColor(self.lineColor)
        }
    }
}

