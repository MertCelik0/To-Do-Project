//
//  Extension.swift
//  Project_To-Do
//
//  Created by Mert Celik on 22.03.2022.
//

import SwiftUI

let appThemeColor: Color = Color(red: 97/255.0, green: 152/255.0, blue: 142/255.0)


extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {

        typealias NativeColor = UIColor

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }
}
