//
//  GodsView.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import SwiftUI

struct GodsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedGod: EgyptianGod? = nil
    @State private var appearedGods: Set<UUID> = []
    
    var body: some View {
        ZStack {
            // Background
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: true) {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.primary)
                            .shadow(color: Theme.primary.opacity(0.5), radius: 10)
                        
                        Text("The Gods")
                            .font(.system(size: 36, weight: .bold, design: .serif))
                            .foregroundColor(Theme.primary)
                        
                        Text("Divine Powers of Ancient Egypt")
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundColor(Theme.primary.opacity(0.7))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                    
                    // Gods Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 20),
                        GridItem(.flexible(), spacing: 20)
                    ], spacing: 20) {
                        ForEach(EgyptianGod.gods.indices, id: \.self) { index in
                            let god = EgyptianGod.gods[index]
                            GodCard(god: god, appeared: appearedGods.contains(god.id)) {
                                selectedGod = god
                            }
                            .onAppear {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.1)) {
                                    _ = appearedGods.insert(god.id)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            
            // Back button
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Menu")
                                .font(.system(size: 18, weight: .semibold, design: .serif))
                        }
                        .foregroundColor(Theme.primary)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Theme.accent.opacity(0.8))
                        .cornerRadius(20)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                }
                Spacer()
            }
            
            // God detail modal
            if let god = selectedGod {
                GodDetailModal(god: god) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        selectedGod = nil
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct GodCard: View {
    let god: EgyptianGod
    let appeared: Bool
    let onTap: () -> Void
    @State private var isPressed = false
    @State private var glowAnimation = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Icon with glow
                ZStack {
                    Circle()
                        .fill(Theme.primary.opacity(glowAnimation ? 0.2 : 0.1))
                        .frame(width: 80, height: 80)
                        .blur(radius: 15)
                    
                    ZStack {
                        Circle()
                            .fill(Theme.accent.opacity(0.8))
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: god.iconName)
                            .font(.system(size: 35, weight: .medium))
                            .foregroundColor(Theme.primary)
                    }
                    .shadow(color: Theme.primary.opacity(0.5), radius: 10)
                }
                
                // Name and symbol
                VStack(spacing: 4) {
                    Text(god.name)
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(Theme.primary)
                    
                    Text(god.symbol)
                        .font(.system(size: 24))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Theme.accent.opacity(0.6))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.3), radius: isPressed ? 4 : 8, x: 0, y: isPressed ? 2 : 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowAnimation = true
            }
        }
    }
}

struct GodDetailModal: View {
    let god: EgyptianGod
    let onDismiss: () -> Void
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 15) {
                    Image(systemName: god.iconName)
                        .font(.system(size: 70))
                        .foregroundColor(Theme.primary)
                        .shadow(color: Theme.primary.opacity(0.5), radius: 15)
                    
                    Text(god.name)
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(Theme.primary)
                    
                    Text(god.title)
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .foregroundColor(Theme.primary.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                Divider()
                    .background(Theme.primary.opacity(0.3))
                    .padding(.horizontal, 20)
                
                // Description
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 15) {
                        Text(god.description)
                            .font(.system(size: 17, weight: .regular, design: .serif))
                            .foregroundColor(Theme.primary.opacity(0.9))
                            .lineSpacing(6)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 25)
                            .padding(.top, 20)
                        
                        // Symbol
                        HStack {
                            Text("Sacred Symbol:")
                                .font(.system(size: 16, weight: .semibold, design: .serif))
                                .foregroundColor(Theme.primary.opacity(0.8))
                            
                            Text(god.symbol)
                                .font(.system(size: 32))
                        }
                        .padding(.top, 10)
                    }
                }
                .frame(maxHeight: 300)
                
                // Close button
                Button(action: dismiss) {
                    Text("Close")
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .foregroundColor(Theme.background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Theme.primary)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 25)
            }
            .frame(maxWidth: 500)
            .background(Theme.accent)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.5), radius: 20)
            .padding(.horizontal, 30)
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
    
    func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            scale = 0.8
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
}

#Preview {
    GodsView()
}

