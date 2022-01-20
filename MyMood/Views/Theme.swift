//
//  Theme.swift
//  MyMood
//
//  Created by Kyle Shores on 1/17/22.
//

import SwiftUI

struct Theme {
    // Color scheme: https://www.schemecolor.com/emotion-and-feelings.php
    static let color1: Color = Color(red:95/255, green:222/255, blue:192/255)
    static let color2: Color = Color(red:100/255, green:180/255, blue:227/255)
    static let color3: Color = Color(red:255/255, green:207/255, blue:51/255)
    static let color4: Color = Color(red:252/255, green:111/255, blue:68/255)
    static let color5: Color = Color(red:224/255, green:81/255, blue:176/255)
    
    
    static func ForegroundGradient() -> some View {
        return LinearGradient(
            gradient: Gradient(colors: [Theme.color5, Theme.color4]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static func BackgroundGradient() -> some View {
        return LinearGradient(
            gradient: Gradient(colors: [Theme.color1, Theme.color2]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static func Heart() -> some View {
        return Image(systemName: "heart.fill")
            .overlayMask(
                ForegroundGradient()
            )
    }
}

extension View {
    func overlayMask<Overlay: View>(_ overlay: Overlay) -> some View {
        self.overlay(overlay).mask(self)
    }
}

let NavigationTitleFormater: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

let DefaultDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

let TimeOnlyDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    return formatter
}()
