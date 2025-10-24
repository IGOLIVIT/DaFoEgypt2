//
//  ContentView.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                MainMenuView()
            } else {
                OnboardingView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
