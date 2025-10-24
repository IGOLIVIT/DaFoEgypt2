//
//  HistoryView.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import SwiftUI

struct HistorySection: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let extendedDescription: String
    let icon: String
}

extension HistorySection {
    static let sections = [
        HistorySection(
            title: "Old Kingdom",
            subtitle: "The Age of the Pyramids (2686-2181 BCE)",
            description: "Pharaohs built monuments to eternity. The Great Pyramids of Giza stand as testament to their ambition and the skill of ancient architects. Khufu's Great Pyramid remained the tallest structure on Earth for 3,800 years.",
            extendedDescription: "During this period, Egypt achieved unprecedented architectural feats. The pyramids were not merely tombs but cosmic machines designed to launch the pharaoh's soul into the afterlife. Thousands of workers (not slaves!) labored voluntarily, housed and fed by the state. The Great Sphinx of Giza was carved during this era, and the solar boat of Khufu was buried beside his pyramid to carry him across the heavens.",
            icon: "pyramid.fill"
        ),
        HistorySection(
            title: "Middle Kingdom",
            subtitle: "The Period of Reunification (2055-1650 BCE)",
            description: "A golden age of art, literature, and prosperity. Egypt stabilized after years of division. The capital moved to Thebes, and pharaohs built massive irrigation projects that transformed the Nile Valley.",
            extendedDescription: "The Middle Kingdom saw Egypt reunited under Theban rule after a chaotic intermediate period. This era produced magnificent literature including 'The Tale of Sinuhe' and 'The Eloquent Peasant.' Trade expanded southward into Nubia and eastward to Punt (modern Somalia). Pharaohs like Senusret III built formidable fortresses along the Nile to protect Egypt's southern borders from invasion.",
            icon: "building.columns.fill"
        ),
        HistorySection(
            title: "New Kingdom",
            subtitle: "Golden Age of Expansion (1550-1077 BCE)",
            description: "The golden age of expansion and great temples. Powerful pharaohs like Hatshepsut, Thutmose III, and Ramesses II extended Egypt's influence from Syria to Sudan. The Valley of the Kings became the eternal resting place of pharaohs.",
            extendedDescription: "The New Kingdom marked Egypt's imperial zenith. Queen Hatshepsut ruled as pharaoh and sent trade expeditions to Punt. Thutmose III conquered lands in 17 military campaigns, creating an empire. Akhenaten revolutionized religion with monotheism. Tutankhamun's tomb, discovered intact in 1922, revealed the splendor of royal burials. Ramesses II built Abu Simbel and fought the Hittites at Kadesh, the first battle recorded in detail.",
            icon: "flame.fill"
        ),
        HistorySection(
            title: "Late Period",
            subtitle: "Foreign Dynasties and Resistance (664-332 BCE)",
            description: "Egypt faced invasions by Persians, Nubians, and Greeks. Despite foreign rule, Egyptian culture remained strong. The Saite Renaissance revived ancient traditions and art styles from the Old Kingdom.",
            extendedDescription: "The Late Period saw Egypt ruled by foreign dynasties including Nubians (25th Dynasty) and Persians (27th Dynasty). The Saite pharaohs (26th Dynasty) from the city of Sais led a cultural renaissance, deliberately imitating Old Kingdom art and architecture. Persian king Cambyses conquered Egypt in 525 BCE. Native Egyptian pharaohs briefly reclaimed independence before Alexander the Great arrived in 332 BCE, welcomed as a liberator from Persian rule.",
            icon: "crown.fill"
        ),
        HistorySection(
            title: "Ptolemaic Era",
            subtitle: "Greek Pharaohs and Cleopatra (332-30 BCE)",
            description: "After Alexander the Great's death, his general Ptolemy founded a Greek dynasty that ruled Egypt for 300 years. Alexandria became the intellectual center of the ancient world with its Great Library and Lighthouse.",
            extendedDescription: "The Ptolemaic Dynasty blended Greek and Egyptian cultures. The Rosetta Stone, created in 196 BCE, would later unlock hieroglyphic writing. Alexandria's Great Library contained 400,000 scrolls, and the Pharos Lighthouse was one of the Seven Wonders. Cleopatra VII, the last pharaoh, allied with Julius Caesar and Marc Antony. Her death in 30 BCE ended pharaonic rule after 3,000 years, and Egypt became a Roman province.",
            icon: "book.fill"
        ),
        HistorySection(
            title: "Daily Life",
            subtitle: "How Ancient Egyptians Lived",
            description: "Ancient Egyptians enjoyed beer and bread, played board games like Senet, and wore linen clothing. Children attended school to learn hieroglyphics. Cats were sacred, and makeup (kohl) was worn by both men and women.",
            extendedDescription: "Most Egyptians were farmers who lived in mud-brick houses along the Nile. They grew wheat, barley, flax, and vegetables in fields flooded annually by the river. Bread and beer were dietary staples. The wealthy enjoyed banquets with music and dancing. Medicine was advanced - doctors performed surgeries and prescribed remedies. Writing was prestigious; scribes held respected positions. Egyptians believed strongly in Ma'at (truth, balance, order) and prepared elaborately for the afterlife.",
            icon: "house.fill"
        ),
        HistorySection(
            title: "Hieroglyphics",
            subtitle: "The Sacred Writing System",
            description: "Hieroglyphics combined logographic, syllabic, and alphabetic elements. Over 700 symbols represented objects, sounds, and ideas. Only scribes mastered this complex script after years of training.",
            extendedDescription: "The word 'hieroglyphics' means 'sacred carvings.' This writing system was used for 3,500 years, appearing on temple walls, papyrus scrolls, and tomb inscriptions. Scribes also used hieratic (cursive hieroglyphics) for daily documents and later demotic for everyday writing. The script was deciphered in 1822 by Jean-François Champollion using the Rosetta Stone, which displayed the same text in hieroglyphics, demotic, and Greek.",
            icon: "character.book.closed.fill"
        ),
        HistorySection(
            title: "Mummification",
            subtitle: "Preserving the Body for Eternity",
            description: "Mummification was a 70-day process to preserve the body for the afterlife. Organs were removed and stored in canopic jars. The body was dried with natron salt, wrapped in linen, and placed in decorated coffins.",
            extendedDescription: "Egyptians believed the soul needed a preserved body to exist in the afterlife. During mummification, embalmers removed all organs except the heart (seat of intelligence). The brain was extracted through the nose and discarded. The body was covered in natron for 40 days to dry it out, then wrapped in hundreds of meters of linen with amulets placed between layers. Priests recited spells during the process. The wealthy received elaborate mummification, while commoners were buried more simply in the desert sand.",
            icon: "figure.stand"
        )
    ]
}

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State private var expandedSections: Set<UUID> = []
    @State private var scrollOffset: CGFloat = 0
    @State private var showReward = false
    
    var allSectionsRead: Bool {
        HistorySection.sections.allSatisfy { section in
            appState.sectionsRead.contains(section.id.uuidString)
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            Theme.backgroundGradient
                .ignoresSafeArea()
            
            // Animated sunlight effect
            SunlightView(offset: scrollOffset)
            
            ScrollView(showsIndicators: true) {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "scroll.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.primary)
                            .shadow(color: Theme.primary.opacity(0.5), radius: 10)
                        
                        Text("Explore Egypt")
                            .font(.system(size: 36, weight: .bold, design: .serif))
                            .foregroundColor(Theme.primary)
                        
                        Text("Journey Through the Ages")
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundColor(Theme.primary.opacity(0.7))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                    
                    // History Sections
                    VStack(spacing: 20) {
                        ForEach(HistorySection.sections) { section in
                            HistorySectionCard(
                                section: section,
                                isExpanded: expandedSections.contains(section.id)
                            ) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    if expandedSections.contains(section.id) {
                                        expandedSections.remove(section.id)
                                    } else {
                                        expandedSections.insert(section.id)
                                        appState.sectionsRead.insert(section.id.uuidString)
                                        
                                        // Check if all sections are now read
                                        if allSectionsRead && !showReward {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                showReward = true
                                                appState.knowledgeGems += 1
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry.frame(in: .named("scroll")).minY
                        )
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
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
            
            // Reward overlay
            if showReward {
                RewardOverlay(gems: 1) {
                    showReward = false
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct HistorySectionCard: View {
    let section: HistorySection
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HStack(spacing: 15) {
                Image(systemName: section.icon)
                    .font(.system(size: 30))
                    .foregroundColor(Theme.primary)
                    .frame(width: 50, height: 50)
                    .background(Theme.accent.opacity(0.3))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(section.title)
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundColor(Theme.primary)
                    
                    Text(section.subtitle)
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .foregroundColor(Theme.primary.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.primary)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            
            // Description
            Text(section.description)
                .font(.system(size: 16, weight: .regular, design: .serif))
                .foregroundColor(Theme.primary.opacity(0.9))
                .lineSpacing(4)
            
            // Extended description (when expanded)
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    Divider()
                        .background(Theme.primary.opacity(0.3))
                        .padding(.vertical, 5)
                    
                    Text(section.extendedDescription)
                        .font(.system(size: 15, weight: .regular, design: .serif))
                        .foregroundColor(Theme.primary.opacity(0.8))
                        .lineSpacing(5)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Read More button
            Button(action: onTap) {
                Text(isExpanded ? "Show Less" : "Read More")
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundColor(Theme.background)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Theme.primary)
                    .cornerRadius(8)
            }
        }
        .padding(20)
        .background(Theme.accent.opacity(0.6))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct SunlightView: View {
    let offset: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            LinearGradient(
                colors: [
                    Theme.primary.opacity(0.1),
                    Color.clear,
                    Theme.primary.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .offset(y: offset * 0.3)
            .blur(radius: 30)
        }
        .ignoresSafeArea()
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct RewardOverlay: View {
    let gems: Int
    let onDismiss: () -> Void
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack(spacing: 20) {
                Image(systemName: "diamond.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Theme.gemBlue)
                    .shadow(color: Theme.gemBlue, radius: 20)
                
                Text("+\(gems) Knowledge Gem\(gems == 1 ? "" : "s")")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(Theme.primary)
                
                Text("Well done, traveler!")
                    .font(.system(size: 20, weight: .medium, design: .serif))
                    .foregroundColor(Theme.primary.opacity(0.8))
                
                Button(action: dismiss) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .foregroundColor(Theme.background)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Theme.primary)
                        .cornerRadius(12)
                }
                .padding(.top, 10)
            }
            .padding(40)
            .background(Theme.accent)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.5), radius: 20)
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
    HistoryView()
        .environmentObject(AppState())
}

