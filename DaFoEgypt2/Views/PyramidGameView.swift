//
//  PyramidGameView.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import SwiftUI

struct PyramidBlock: Identifiable, Equatable {
    let id = UUID()
    let level: Int // Уровень пирамиды (1-5)
    var isPlaced: Bool = false
    var slotIndex: Int = -1 // Индекс слота, куда помещен блок
}

struct PyramidGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State private var blocks: [PyramidBlock] = []
    @State private var gameCompleted = false
    @State private var moves = 0
    @State private var showCelebration = false
    @State private var showTutorial = true
    
    let pyramidLevels = [5, 4, 3, 2, 1] // Количество блоков на каждом уровне
    let blockHeight: CGFloat = 35
    let blockSpacing: CGFloat = 2
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Theme.backgroundGradient
                    .ignoresSafeArea()
                
                if showTutorial {
                    TutorialOverlay {
                        withAnimation {
                            showTutorial = false
                        }
                    }
                } else if gameCompleted {
                    GameCompletionView(moves: moves) {
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack(spacing: 5) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Menu")
                                        .font(.system(size: 16, weight: .semibold, design: .serif))
                                }
                                .foregroundColor(Theme.primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Theme.accent.opacity(0.8))
                                .cornerRadius(15)
                            }
                            
                            Spacer()
                            
                            // Moves counter
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 14))
                                Text("\(moves)")
                                    .font(.system(size: 16, weight: .bold, design: .serif))
                            }
                            .foregroundColor(Theme.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Theme.accent.opacity(0.8))
                            .cornerRadius(15)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, geometry.safeAreaInsets.top + 10)
                        
                        // Title
                        VStack(spacing: 8) {
                            Image(systemName: "pyramid.fill")
                                .font(.system(size: 30))
                                .foregroundColor(Theme.primary)
                            
                            Text("Build the Pyramid")
                                .font(.system(size: 24, weight: .bold, design: .serif))
                                .foregroundColor(Theme.primary)
                        }
                        .padding(.top, 15)
                        
                        Spacer()
                        
                        // Pyramid area
                        PyramidAreaView(
                            blocks: blocks,
                            geometry: geometry,
                            blockHeight: blockHeight,
                            blockSpacing: blockSpacing,
                            onBlockPlaced: handleBlockPlacement
                        )
                        .frame(height: calculatePyramidHeight())
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        // Available blocks
                        VStack(spacing: 10) {
                            Text("Drag blocks here:")
                                .font(.system(size: 14, weight: .medium, design: .serif))
                                .foregroundColor(Theme.primary.opacity(0.7))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(blocks.filter { !$0.isPlaced }) { block in
                                        DraggableBlockView(
                                            block: block,
                                            blockHeight: blockHeight,
                                            onDragEnded: { location in
                                                handleBlockDrop(block: block, at: location, in: geometry)
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .frame(height: blockHeight + 20)
                        }
                        .padding(.vertical, 15)
                        
                        // Reset button
                        Button(action: resetGame) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Reset")
                            }
                        }
                        .buttonStyle(EgyptianButtonStyle())
                        .padding(.horizontal, 40)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 15)
                    }
                }
                
                // Celebration overlay
                if showCelebration {
                    CelebrationOverlay()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupGame()
        }
    }
    
    func calculatePyramidHeight() -> CGFloat {
        let totalHeight = CGFloat(pyramidLevels.count) * (blockHeight + blockSpacing)
        return totalHeight + 40
    }
    
    func setupGame() {
        var allBlocks: [PyramidBlock] = []
        for level in pyramidLevels {
            for _ in 0..<level {
                allBlocks.append(PyramidBlock(level: level))
            }
        }
        blocks = allBlocks.shuffled()
        moves = 0
    }
    
    func resetGame() {
        withAnimation {
            blocks = blocks.map { block in
                var newBlock = block
                newBlock.isPlaced = false
                newBlock.slotIndex = -1
                return newBlock
            }.shuffled()
            moves = 0
            gameCompleted = false
        }
    }
    
    func handleBlockPlacement(block: PyramidBlock, slotIndex: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if let index = blocks.firstIndex(where: { $0.id == block.id }) {
                blocks[index].isPlaced = true
                blocks[index].slotIndex = slotIndex
                moves += 1
            }
        }
        checkCompletion()
    }
    
    func handleBlockDrop(block: PyramidBlock, at location: CGPoint, in geometry: GeometryProxy) {
        // Simplified placement - any available slot
        let availableSlots = getAvailableSlots()
        if !availableSlots.isEmpty {
            let slotIndex = availableSlots.randomElement() ?? 0
            handleBlockPlacement(block: block, slotIndex: slotIndex)
        }
    }
    
    func getAvailableSlots() -> [Int] {
        let totalSlots = pyramidLevels.reduce(0, +)
        let usedSlots = Set(blocks.filter { $0.isPlaced }.map { $0.slotIndex })
        return (0..<totalSlots).filter { !usedSlots.contains($0) }
    }
    
    func checkCompletion() {
        if blocks.allSatisfy({ $0.isPlaced }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    gameCompleted = true
                    showCelebration = true
                    appState.knowledgeGems += 3
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showCelebration = false
                }
            }
        }
    }
}

// MARK: - Pyramid Area View
struct PyramidAreaView: View {
    let blocks: [PyramidBlock]
    let geometry: GeometryProxy
    let blockHeight: CGFloat
    let blockSpacing: CGFloat
    let onBlockPlaced: (PyramidBlock, Int) -> Void
    
    let pyramidLevels = [5, 4, 3, 2, 1]
    
    var body: some View {
        VStack(spacing: blockSpacing) {
            ForEach(0..<pyramidLevels.count, id: \.self) { levelIndex in
                let level = pyramidLevels[levelIndex]
                PyramidLevelView(
                    level: level,
                    levelIndex: levelIndex,
                    blocks: blocks,
                    blockHeight: blockHeight,
                    availableWidth: geometry.size.width - 40
                )
            }
        }
    }
}

struct PyramidLevelView: View {
    let level: Int
    let levelIndex: Int
    let blocks: [PyramidBlock]
    let blockHeight: CGFloat
    let availableWidth: CGFloat
    
    var blockWidth: CGFloat {
        let maxBlocks: CGFloat = 5
        let spacing: CGFloat = 2
        return (availableWidth - (spacing * (maxBlocks - 1))) / maxBlocks
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<level, id: \.self) { blockIndex in
                let slotIndex = getSlotIndex(level: levelIndex, blockIndex: blockIndex)
                let placedBlock = blocks.first { $0.isPlaced && $0.slotIndex == slotIndex }
                
                if let block = placedBlock {
                    PlacedBlockView(level: block.level, blockHeight: blockHeight)
                        .frame(width: blockWidth, height: blockHeight)
                } else {
                    TargetSlotView()
                        .frame(width: blockWidth, height: blockHeight)
                }
            }
        }
    }
    
    func getSlotIndex(level: Int, blockIndex: Int) -> Int {
        var index = 0
        for i in 0..<level {
            index += [5, 4, 3, 2, 1][i]
        }
        return index + blockIndex
    }
}

// MARK: - Draggable Block View
struct DraggableBlockView: View {
    let block: PyramidBlock
    let blockHeight: CGFloat
    let onDragEnded: (CGPoint) -> Void
    
    @State private var isDragging = false
    @State private var dragOffset: CGSize = .zero
    
    var blockWidth: CGFloat {
        return CGFloat(block.level) * 30
    }
    
    var blockColor: Color {
        switch block.level {
        case 5: return Color(hex: "8B7355")
        case 4: return Color(hex: "A0826D")
        case 3: return Color(hex: "B69A85")
        case 2: return Color(hex: "C5A890")
        case 1: return Theme.primary
        default: return Theme.accent
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [blockColor, blockColor.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(isDragging ? 0.4 : 0.2), radius: isDragging ? 8 : 4, x: 0, y: isDragging ? 6 : 3)
            
            // Texture
            VStack(spacing: 5) {
                ForEach(0..<2, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.black.opacity(0.1))
                        .frame(height: 1)
                }
            }
            .frame(width: blockWidth - 10)
        }
        .frame(width: blockWidth, height: blockHeight)
        .scaleEffect(isDragging ? 1.1 : 1.0)
        .offset(dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    dragOffset = value.translation
                }
                .onEnded { value in
                    isDragging = false
                    onDragEnded(value.location)
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        dragOffset = .zero
                    }
                }
        )
    }
}

// MARK: - Placed Block View
struct PlacedBlockView: View {
    let level: Int
    let blockHeight: CGFloat
    
    var blockColor: Color {
        switch level {
        case 5: return Color(hex: "8B7355")
        case 4: return Color(hex: "A0826D")
        case 3: return Color(hex: "B69A85")
        case 2: return Color(hex: "C5A890")
        case 1: return Theme.primary
        default: return Theme.accent
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [blockColor, blockColor.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
        }
    }
}

// MARK: - Target Slot View
struct TargetSlotView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .stroke(Theme.primary.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [4, 4]))
    }
}

// MARK: - Tutorial Overlay
struct TutorialOverlay: View {
    let onDismiss: () -> Void
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack(spacing: 25) {
                // Icon
                Image(systemName: "hand.draw.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Theme.primary)
                
                // Title
                Text("How to Play")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(Theme.primary)
                
                // Instructions
                VStack(alignment: .leading, spacing: 15) {
                    InstructionRow(
                        icon: "1.circle.fill",
                        text: "Drag blocks from bottom"
                    )
                    
                    InstructionRow(
                        icon: "2.circle.fill",
                        text: "Drop to build pyramid"
                    )
                    
                    InstructionRow(
                        icon: "3.circle.fill",
                        text: "Fill all empty slots"
                    )
                    
                    InstructionRow(
                        icon: "diamond.fill",
                        text: "Earn 3 Knowledge Gems!"
                    )
                }
                .padding(.horizontal, 20)
                
                // Start button
                Button(action: dismiss) {
                    Text("Start Building!")
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(Theme.background)
                        .padding()
                        .frame(maxWidth: 250)
                        .background(Theme.primary)
                        .cornerRadius(12)
                }
                .padding(.top, 10)
            }
            .padding(30)
            .background(Theme.accent)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.5), radius: 20)
            .padding(.horizontal, 40)
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

struct InstructionRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Theme.primary)
                .frame(width: 25)
            
            Text(text)
                .font(.system(size: 16, weight: .medium, design: .serif))
                .foregroundColor(Theme.primary)
        }
    }
}

// MARK: - Game Completion View
struct GameCompletionView: View {
    let moves: Int
    let onDismiss: () -> Void
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotationAngle: Double = 0
    
    var performanceMessage: String {
        switch moves {
        case 0...20: return "Master Builder!"
        case 21...35: return "Expert Architect!"
        case 36...50: return "Skilled Constructor!"
        default: return "Pyramid Complete!"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Spacer()
                    
                    // Pyramid icon
                    Image(systemName: "pyramid.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Theme.primary)
                        .shadow(color: Theme.primary.opacity(0.5), radius: 20)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    // Completion message
                    VStack(spacing: 12) {
                        Text(performanceMessage)
                            .font(.system(size: 30, weight: .bold, design: .serif))
                            .foregroundColor(Theme.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("Completed in \(moves) moves")
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundColor(Theme.primary.opacity(0.8))
                    }
                    
                    // Gems earned
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            ForEach(0..<3, id: \.self) { _ in
                                Image(systemName: "diamond.fill")
                                    .font(.system(size: 35))
                                    .foregroundColor(Theme.gemBlue)
                                    .shadow(color: Theme.gemBlue, radius: 10)
                            }
                        }
                        
                        Text("+3 Knowledge Gems!")
                            .font(.system(size: 16, weight: .bold, design: .serif))
                            .foregroundColor(Theme.gemBlue)
                    }
                    .padding(.top, 15)
                    
                    Spacer()
                    
                    // Return button
                    Button(action: onDismiss) {
                        Text("Return to Menu")
                    }
                    .buttonStyle(EgyptianButtonStyle())
                    .padding(.horizontal, 40)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                }
                .scaleEffect(scale)
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}

// MARK: - Celebration Overlay
struct CelebrationOverlay: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: 8, height: 8)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    func generateParticles(in size: CGSize) {
        for _ in 0..<30 {
            let particle = ConfettiParticle(
                position: CGPoint(x: size.width / 2, y: size.height / 2),
                color: [Theme.primary, Theme.gemBlue, .green, .orange].randomElement()!
            )
            particles.append(particle)
            animateParticle(particle, in: size)
        }
    }
    
    func animateParticle(_ particle: ConfettiParticle, in size: CGSize) {
        withAnimation(.easeOut(duration: 1.5)) {
            if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                particles[index].position = CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                )
                particles[index].opacity = 0
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    var opacity: Double = 1.0
}

#Preview {
    PyramidGameView()
        .environmentObject(AppState())
}
