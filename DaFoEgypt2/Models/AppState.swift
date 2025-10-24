//
//  AppState.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var knowledgeGems: Int = 0 {
        didSet {
            UserDefaults.standard.set(knowledgeGems, forKey: "knowledgeGems")
        }
    }
    
    @Published var hasCompletedOnboarding: Bool = false {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    @Published var sectionsRead: Set<String> = [] {
        didSet {
            if let encoded = try? JSONEncoder().encode(sectionsRead) {
                UserDefaults.standard.set(encoded, forKey: "sectionsRead")
            }
        }
    }
    
    @Published var quizzesTaken: Int = 0 {
        didSet {
            UserDefaults.standard.set(quizzesTaken, forKey: "quizzesTaken")
        }
    }
    
    init() {
        self.knowledgeGems = UserDefaults.standard.integer(forKey: "knowledgeGems")
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.quizzesTaken = UserDefaults.standard.integer(forKey: "quizzesTaken")
        
        if let data = UserDefaults.standard.data(forKey: "sectionsRead"),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            self.sectionsRead = decoded
        } else {
            self.sectionsRead = []
        }
    }
    
    func resetProgress() {
        knowledgeGems = 0
        hasCompletedOnboarding = true // Keep onboarding completed
        sectionsRead = []
        quizzesTaken = 0
    }
}

