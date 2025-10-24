//
//  MainMenuView.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var appState: AppState
    @State private var showHistory = false
    @State private var showGods = false
    @State private var showQuiz = false
    @State private var showPyramidGame = false
    @State private var showSettings = false
    @State private var buttonsAppeared = false
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Theme.backgroundGradient
                    .ignoresSafeArea()
                
                // Subtle texture overlay
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.accent.opacity(0.1), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 30) {
                        Spacer()
                            .frame(height: 20)
                        
                        // Knowledge Gems Display
                        KnowledgeGemsView(gems: appState.knowledgeGems)
                            .padding(.top, 20)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        // Menu Buttons
                        VStack(spacing: 20) {
                            MenuButton(
                                title: "Explore Egypt",
                                icon: "pyramid.fill",
                                delay: 0.1
                            ) {
                                showHistory = true
                            }
                            
                            MenuButton(
                                title: "The Gods",
                                icon: "sparkles",
                                delay: 0.2
                            ) {
                                showGods = true
                            }
                            
                            MenuButton(
                                title: "Challenge of Wisdom",
                                icon: "brain.head.profile",
                                delay: 0.3
                            ) {
                                showQuiz = true
                            }
                            
                            MenuButton(
                                title: "Build the Pyramid",
                                icon: "square.stack.3d.up.fill",
                                delay: 0.4
                            ) {
                                showPyramidGame = true
                            }
                            
                            MenuButton(
                                title: "Settings",
                                icon: "gearshape.fill",
                                delay: 0.5
                            ) {
                                showSettings = true
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer()
                            .frame(height: 40)
                    }
                }
                
                // Navigation Links
                NavigationLink(destination: HistoryView(), isActive: $showHistory) {
                    EmptyView()
                }
                NavigationLink(destination: GodsView(), isActive: $showGods) {
                    EmptyView()
                }
                NavigationLink(destination: QuizView(), isActive: $showQuiz) {
                    EmptyView()
                }
                NavigationLink(destination: PyramidGameView(), isActive: $showPyramidGame) {
                    EmptyView()
                }
                NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct KnowledgeGemsView: View {
    let gems: Int
    @State private var glowAnimation = false
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                // Glow effect
                Circle()
                    .fill(Theme.gemBlue.opacity(glowAnimation ? 0.3 : 0.1))
                    .frame(width: 80, height: 80)
                    .blur(radius: 10)
                    .scaleEffect(glowAnimation ? 1.2 : 1.0)
                
                // Gem icon
                Image(systemName: "diamond.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Theme.gemBlue)
                    .shadow(color: Theme.gemBlue.opacity(0.8), radius: 10, x: 0, y: 0)
            }
            
            VStack(spacing: 5) {
                Text("Your Knowledge Gems")
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .foregroundColor(Theme.primary.opacity(0.8))
                
                Text("\(gems)")
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .foregroundColor(Theme.primary)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                glowAnimation = true
            }
        }
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let delay: Double
    let action: () -> Void
    
    @State private var appeared = false
    
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
        }
        .buttonStyle(MenuButtonStyle())
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : -50)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(delay)) {
                appeared = true
            }
        }
    }
}

#Preview {
    MainMenuView()
        .environmentObject(AppState())
}

