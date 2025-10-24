//
//  SettingsView.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State private var showResetAlert = false
    @State private var showStatistics = false
    @State private var appearedButtons = false
    
    var body: some View {
        ZStack {
            // Background
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            // Papyrus texture
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Theme.accent.opacity(0.15), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: true) {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.primary)
                            .shadow(color: Theme.primary.opacity(0.5), radius: 10)
                        
                        Text("Settings")
                            .font(.system(size: 36, weight: .bold, design: .serif))
                            .foregroundColor(Theme.primary)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                    
                    // Options
                    VStack(spacing: 20) {
                        SettingsButton(
                            title: "View Your Statistics",
                            icon: "chart.bar.fill",
                            appeared: appearedButtons
                        ) {
                            showStatistics = true
                        }
                        
                        SettingsButton(
                            title: "Reset Progress",
                            icon: "arrow.counterclockwise",
                            appeared: appearedButtons,
                            isDestructive: true
                        ) {
                            showResetAlert = true
                        }
                    }
                    .padding(.horizontal, 30)
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
            
            // Statistics modal
            if showStatistics {
                StatisticsModal(onDismiss: {
                    showStatistics = false
                })
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Reset Progress"),
                message: Text("Are you sure you want to start again? All your Knowledge Gems and progress will be lost."),
                primaryButton: .destructive(Text("Reset")) {
                    appState.resetProgress()
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                appearedButtons = true
            }
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let appeared: Bool
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .frame(width: 30)
                
                Text(title)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(isDestructive ? .red.opacity(0.9) : Theme.background)
        }
        .buttonStyle(MenuButtonStyle())
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : -50)
    }
}

struct StatisticsModal: View {
    @EnvironmentObject var appState: AppState
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
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Theme.primary)
                        .shadow(color: Theme.primary.opacity(0.5), radius: 10)
                    
                    Text("Your Statistics")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(Theme.primary)
                }
                .padding(.top, 30)
                .padding(.bottom, 30)
                
                Divider()
                    .background(Theme.primary.opacity(0.3))
                    .padding(.horizontal, 20)
                
                // Statistics
                VStack(spacing: 25) {
                    StatRow(
                        icon: "diamond.fill",
                        iconColor: Theme.gemBlue,
                        label: "Total Knowledge Gems",
                        value: "\(appState.knowledgeGems)"
                    )
                    
                    StatRow(
                        icon: "book.fill",
                        iconColor: Theme.primary,
                        label: "Sections Completed",
                        value: "\(appState.sectionsRead.count)"
                    )
                    
                    StatRow(
                        icon: "brain.head.profile",
                        iconColor: Theme.primary,
                        label: "Quizzes Taken",
                        value: "\(appState.quizzesTaken)"
                    )
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 25)
                
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
                .padding(.bottom, 25)
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

struct StatRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .foregroundColor(Theme.primary.opacity(0.8))
                
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(Theme.primary)
            }
            
            Spacer()
        }
        .padding(15)
        .background(Theme.primary.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}

