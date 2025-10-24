//
//  QuizView.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import SwiftUI

struct QuizView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var gemsEarned = 0
    @State private var quizCompleted = false
    @State private var shakeAnimation = false
    @State private var questions: [QuizQuestion] = []
    @State private var selectedDifficulty: QuizDifficulty? = nil
    @State private var showExplanation = false
    
    var body: some View {
        ZStack {
            // Background
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            // Papyrus texture overlay
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Theme.accent.opacity(0.2), Color.clear, Theme.accent.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
            
            if selectedDifficulty == nil {
                // Difficulty selection screen
                DifficultySelectionView { difficulty in
                    selectedDifficulty = difficulty
                    setupQuiz(difficulty: difficulty)
                }
            } else if quizCompleted {
                QuizCompletionView(gemsEarned: gemsEarned, difficulty: selectedDifficulty!) {
                    presentationMode.wrappedValue.dismiss()
                }
            } else {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.primary)
                            .shadow(color: Theme.primary.opacity(0.5), radius: 10)
                        
                        Text("Challenge of Wisdom")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(Theme.primary)
                        
                        Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                            .font(.system(size: 16, weight: .medium, design: .serif))
                            .foregroundColor(Theme.primary.opacity(0.7))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                    
                        ScrollView(showsIndicators: true) {
                        VStack(spacing: 30) {
                            // Question card
                            if currentQuestionIndex < questions.count {
                                let question = questions[currentQuestionIndex]
                                
                                VStack(spacing: 25) {
                                    // Question text
                                    Text(question.question)
                                        .font(.system(size: 24, weight: .semibold, design: .serif))
                                        .foregroundColor(Theme.primary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                        .padding(.top, 30)
                                    
                                    // Answer options
                                    VStack(spacing: 15) {
                                        ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                                            AnswerButton(
                                                text: option,
                                                isSelected: selectedAnswer == index,
                                                isCorrect: showResult && index == question.correctAnswer,
                                                isWrong: showResult && selectedAnswer == index && index != question.correctAnswer,
                                                shake: shakeAnimation && selectedAnswer == index && index != question.correctAnswer
                                            ) {
                                                if !showResult {
                                                    selectedAnswer = index
                                                    checkAnswer(question: question, selectedIndex: index)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 30)
                                }
                                .background(Theme.accent.opacity(0.6))
                                .cornerRadius(20)
                                .padding(.horizontal, 20)
                            }
                            
                            // Next button
                            if showResult {
                                Button(action: nextQuestion) {
                                    Text(currentQuestionIndex < questions.count - 1 ? "Next Question" : "Complete Quiz")
                                }
                                .buttonStyle(EgyptianButtonStyle())
                                .padding(.horizontal, 40)
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            
            // Back button
            if !quizCompleted {
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
            }
            
            // Result overlay
            if showResult && !quizCompleted {
                ResultFeedback(isCorrect: isCorrect)
            }
        }
        .navigationBarHidden(true)
    }
    
    func setupQuiz(difficulty: QuizDifficulty) {
        let availableQuestions = QuizQuestion.questions(for: difficulty)
        questions = availableQuestions.shuffled().prefix(5).map { $0 }
        currentQuestionIndex = 0
        selectedAnswer = nil
        showResult = false
        showExplanation = false
        gemsEarned = 0
        quizCompleted = false
    }
    
    func checkAnswer(question: QuizQuestion, selectedIndex: Int) {
        isCorrect = selectedIndex == question.correctAnswer
        
        if isCorrect {
            gemsEarned += 1
            appState.knowledgeGems += 1
        } else {
            withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
                shakeAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                shakeAnimation = false
            }
        }
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.5)) {
            showResult = true
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentQuestionIndex += 1
                selectedAnswer = nil
                showResult = false
            }
        } else {
            appState.quizzesTaken += 1
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                quizCompleted = true
            }
        }
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let shake: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if isCorrect {
            return Color.green.opacity(0.3)
        } else if isWrong {
            return Color.red.opacity(0.3)
        } else if isSelected {
            return Theme.primary.opacity(0.3)
        } else {
            return Theme.primary.opacity(0.1)
        }
    }
    
    var borderColor: Color {
        if isCorrect {
            return Color.green
        } else if isWrong {
            return Color.red
        } else if isSelected {
            return Theme.primary
        } else {
            return Theme.primary.opacity(0.5)
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundColor(Theme.primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                } else if isWrong {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(12)
        }
        .disabled(isCorrect || isWrong)
        .offset(x: shake ? -10 : 0)
    }
}

struct ResultFeedback: View {
    let isCorrect: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(isCorrect ? .green : .red)
                .shadow(color: isCorrect ? .green.opacity(0.5) : .red.opacity(0.5), radius: 20)
            
            if isCorrect {
                VStack(spacing: 10) {
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Theme.gemBlue)
                        .shadow(color: Theme.gemBlue, radius: 10)
                    
                    Text("+1 Knowledge Gem")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundColor(Theme.primary)
                }
            }
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Theme.accent.opacity(0.95))
                .shadow(color: .black.opacity(0.3), radius: 20)
        )
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.3)) {
                    opacity = 0
                }
            }
        }
    }
}

// MARK: - Difficulty Selection View
struct DifficultySelectionView: View {
    let onSelect: (QuizDifficulty) -> Void
    @State private var appearedButtons = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Header
            VStack(spacing: 15) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Theme.primary)
                    .shadow(color: Theme.primary.opacity(0.5), radius: 15)
                
                Text("Choose Your Level")
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .foregroundColor(Theme.primary)
                    .multilineTextAlignment(.center)
                
                Text("Select difficulty to begin")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundColor(Theme.primary.opacity(0.8))
            }
            
            Spacer()
            
            // Difficulty buttons
            VStack(spacing: 20) {
                DifficultyButton(
                    difficulty: .easy,
                    icon: "1.circle.fill",
                    description: "Perfect for beginners",
                    appeared: appearedButtons,
                    delay: 0.1
                ) {
                    onSelect(.easy)
                }
                
                DifficultyButton(
                    difficulty: .medium,
                    icon: "2.circle.fill",
                    description: "Test your knowledge",
                    appeared: appearedButtons,
                    delay: 0.2
                ) {
                    onSelect(.medium)
                }
                
                DifficultyButton(
                    difficulty: .hard,
                    icon: "3.circle.fill",
                    description: "For true experts",
                    appeared: appearedButtons,
                    delay: 0.3
                ) {
                    onSelect(.hard)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                appearedButtons = true
            }
        }
    }
}

struct DifficultyButton: View {
    let difficulty: QuizDifficulty
    let icon: String
    let description: String
    let appeared: Bool
    let delay: Double
    let action: () -> Void
    
    var difficultyColor: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(difficultyColor)
                    .frame(width: 60)
                
                // Text
                VStack(alignment: .leading, spacing: 5) {
                    Text(difficulty.rawValue)
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundColor(Theme.primary)
                    
                    Text(description)
                        .font(.system(size: 14, weight: .medium, design: .serif))
                        .foregroundColor(Theme.primary.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Theme.primary)
            }
            .padding(20)
            .background(Theme.accent.opacity(0.6))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(difficultyColor.opacity(0.5), lineWidth: 2)
            )
            .shadow(color: difficultyColor.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : -50)
        .animation(.easeOut(duration: 0.5).delay(delay), value: appeared)
    }
}

// MARK: - Updated Completion View
struct QuizCompletionView: View {
    let gemsEarned: Int
    let difficulty: QuizDifficulty
    let onDismiss: () -> Void
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var confettiAnimation = false
    
    var performanceMessage: String {
        let percentage = (Double(gemsEarned) / 5.0) * 100
        switch percentage {
        case 100: return "Perfect Score! Outstanding!"
        case 80..<100: return "Excellent Work!"
        case 60..<80: return "Good Job!"
        case 40..<60: return "Not Bad!"
        default: return "Keep Learning!"
        }
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Trophy icon
                Image(systemName: "trophy.fill")
                    .font(.system(size: 100))
                    .foregroundColor(Theme.primary)
                    .shadow(color: Theme.primary.opacity(0.5), radius: 20)
                    .scaleEffect(confettiAnimation ? 1.1 : 1.0)
                
                // Difficulty badge
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                    Text(difficulty.rawValue)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(difficulty == .easy ? Color.green : difficulty == .medium ? Color.orange : Color.red)
                )
                
                // Completion message
                VStack(spacing: 15) {
                    Text(performanceMessage)
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundColor(Theme.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("You earned \(gemsEarned) out of 5 Knowledge Gems")
                        .font(.system(size: 20, weight: .medium, design: .serif))
                        .foregroundColor(Theme.primary.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                // Gems display
                HStack(spacing: 15) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < gemsEarned ? "diamond.fill" : "diamond")
                            .font(.system(size: 40))
                            .foregroundColor(index < gemsEarned ? Theme.gemBlue : Theme.primary.opacity(0.3))
                            .shadow(color: index < gemsEarned ? Theme.gemBlue : .clear, radius: 10)
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Return button
                Button(action: onDismiss) {
                    Text("Return to Menu")
                }
                .buttonStyle(EgyptianButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                confettiAnimation = true
            }
        }
    }
}

#Preview {
    QuizView()
        .environmentObject(AppState())
}

