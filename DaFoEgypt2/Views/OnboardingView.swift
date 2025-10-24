//
//  OnboardingView.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    @State private var fadeIn = false
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            Theme.background
                .ignoresSafeArea()
            
            // Animated particles
            ParticleView()
            
            TabView(selection: $currentPage) {
                OnboardingPage(
                    imageName: "pyramid.fill",
                    headline: "Step into the land where gods walked among men.",
                    pageNumber: 0
                )
                .tag(0)
                
                OnboardingPage(
                    imageName: "building.columns.fill",
                    headline: "Uncover the stories of pharaohs and forgotten dynasties.",
                    pageNumber: 1
                )
                .tag(1)
                
                OnboardingPage(
                    imageName: "sparkles",
                    headline: "Test your wisdom and earn Knowledge Gems.",
                    pageNumber: 2,
                    showButton: true,
                    buttonAction: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            appState.hasCompletedOnboarding = true
                        }
                    }
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                fadeIn = true
            }
        }
    }
}

struct OnboardingPage: View {
    let imageName: String
    let headline: String
    let pageNumber: Int
    var showButton: Bool = false
    var buttonAction: (() -> Void)? = nil
    
    @State private var iconScale: CGFloat = 0.5
    @State private var textOpacity: Double = 0
    @State private var buttonOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated Icon
            ZStack {
                Circle()
                    .fill(Theme.primary.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .blur(radius: 20)
                
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(Theme.primary)
                    .scaleEffect(iconScale)
            }
            .shadow(color: Theme.primary.opacity(0.5), radius: 30, x: 0, y: 10)
            
            // Headline
            Text(headline)
                .font(.system(size: 28, weight: .semibold, design: .serif))
                .foregroundColor(Theme.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(textOpacity)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            
            if showButton {
                Button(action: {
                    buttonAction?()
                }) {
                    Text("Begin Your Journey")
                }
                .buttonStyle(EgyptianButtonStyle())
                .padding(.horizontal, 40)
                .opacity(buttonOpacity)
            }
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                iconScale = 1.0
            }
            withAnimation(.easeIn(duration: 0.8).delay(0.5)) {
                textOpacity = 1.0
            }
            if showButton {
                withAnimation(.easeIn(duration: 0.8).delay(0.8)) {
                    buttonOpacity = 1.0
                }
            }
        }
    }
}

// Particle animation view
struct ParticleView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(Theme.primary.opacity(0.3))
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .blur(radius: 2)
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
            }
        }
        .ignoresSafeArea()
    }
    
    func generateParticles(in size: CGSize) {
        for _ in 0..<15 {
            let particle = Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                size: CGFloat.random(in: 2...6)
            )
            particles.append(particle)
            animateParticle(particle, in: size)
        }
    }
    
    func animateParticle(_ particle: Particle, in size: CGSize) {
        withAnimation(
            .linear(duration: Double.random(in: 3...6))
            .repeatForever(autoreverses: false)
        ) {
            if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                particles[index].position.y -= CGFloat.random(in: 50...150)
            }
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}

