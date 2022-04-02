//
//  Extension.swift
//  Project_To-Do
//
//  Created by Mert Celik on 22.03.2022.
//

import SwiftUI

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

extension Date {
    
    // convert date string
    func getFormattedDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    // convert string date
    func getStringDate(from date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: date) ?? Date()
    }

    // Returns hour and minutes range string
    func range(from date: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.hour, .minute]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: getStringDate(from: getFormattedDateString(from: date)), to: self)
        let minutes = difference.minute == 0 ? "" : "\(difference.minute!)m"
        let hours = difference.hour == 0 ? "" + minutes : "\(difference.hour!)h" + (difference.minute == 0 ? "" : " " + minutes)
        return hours
    }
    
    // Returns minutes range Int
    func rangeInt(from date: Date) -> Int {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: getStringDate(from: getFormattedDateString(from: date)), to: self).minute ?? 0
        return difference
    }
}


//MARK: UI Design helper functions
extension View {
    func hLeading() -> some View { self
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View { self
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View { self
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    //MARK: Safe Area
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
            clipShape( RoundedCorner(radius: radius, corners: corners) )
        }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
