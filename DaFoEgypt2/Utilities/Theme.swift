//
//  Theme.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import SwiftUI

struct Theme {
    // Color Palette
    static let background = Color(hex: "2D1B0E")
    static let primary = Color(hex: "C5A446")
    static let accent = Color(hex: "6C4223")
    static let gemBlue = Color(hex: "4DA6FF")
    
    // Gradients
    static let goldGradient = LinearGradient(
        colors: [Color(hex: "C5A446"), Color(hex: "E8C468")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [Color(hex: "2D1B0E"), Color(hex: "3D2B1E")],
        startPoint: .top,
        endPoint: .bottom
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Custom Button Styles
struct EgyptianButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Theme.primary)
            .foregroundColor(Theme.background)
            .font(.system(size: 18, weight: .semibold, design: .serif))
            .cornerRadius(12)
            .shadow(color: Theme.primary.opacity(0.5), radius: configuration.isPressed ? 2 : 8, x: 0, y: configuration.isPressed ? 2 : 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct MenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Theme.primary)
                    .shadow(color: Theme.primary.opacity(0.4), radius: configuration.isPressed ? 2 : 10, x: 0, y: configuration.isPressed ? 2 : 5)
            )
            .foregroundColor(Theme.background)
            .font(.system(size: 20, weight: .bold, design: .serif))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

