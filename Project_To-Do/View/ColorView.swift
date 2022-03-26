//
//  ColorView.swift
//  Project_To-Do
//
//  Created by Mert Celik on 24.03.2022.
//

import SwiftUI

struct ColorView: View {

    @Binding var selectionColor: Color
    
    let swatches = [
        Color(red: 97/255.0, green: 152/255.0, blue: 142/255.0),
        Color(red: 64/255.0, green: 64/255.0, blue: 122/255.0),
        Color(red: 214/255.0, green: 84/255.0, blue: 97/255.0),
        Color(red: 255/255.0, green: 191/255.0, blue: 105/255.0)
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(swatches, id: \.self){ swatch in
                ZStack {
                    Rectangle()
                        .fill(selectionColor.opacity(0.2))
                    Circle()
                        .fill(swatch)
                        .frame(width: selectionColor == swatch ? 18 : 25, height: selectionColor == swatch ? 18 : 25)
                        .onTapGesture(perform: {
                            selectionColor = swatch
                        })
                    if selectionColor == swatch {
                        Circle()
                            .stroke(swatch, lineWidth: 3)
                            .frame(width: 25, height: 25)
                    }
                    
                }
            }
            ZStack {
                Rectangle()
                    .fill(selectionColor.opacity(0.2))
                ColorPicker("", selection: $selectionColor)
                    .padding()

            }
        }
        .frame(height: 50)
        .cornerRadius(10)
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView(selectionColor: .constant(Color(red: 97/255.0, green: 152/255.0, blue: 142/255.0)))
    }
}
