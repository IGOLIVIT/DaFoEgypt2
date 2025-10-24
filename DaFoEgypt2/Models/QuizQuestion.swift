//
//  QuizQuestion.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import Foundation

enum QuizDifficulty: String, CaseIterable {
    case easy = "Beginner"
    case medium = "Intermediate"
    case hard = "Expert"
    
    var color: String {
        switch self {
        case .easy: return "green"
        case .medium: return "orange"
        case .hard: return "red"
        }
    }
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
    let difficulty: QuizDifficulty
    let explanation: String
}

extension QuizQuestion {
    // EASY QUESTIONS (Beginner Level)
    static let easyQuestions = [
        QuizQuestion(
            question: "Which god guarded the underworld?",
            options: ["Ra", "Anubis", "Horus", "Set"],
            correctAnswer: 1,
            difficulty: .easy,
            explanation: "Anubis, the jackal-headed god, was the guardian of the dead and the underworld."
        ),
        QuizQuestion(
            question: "Who was the sun god and creator?",
            options: ["Osiris", "Anubis", "Ra", "Thoth"],
            correctAnswer: 2,
            difficulty: .easy,
            explanation: "Ra was the mighty sun god who sailed across the sky each day in his solar barque."
        ),
        QuizQuestion(
            question: "Which goddess was known for magic and motherhood?",
            options: ["Isis", "Nephthys", "Hathor", "Nut"],
            correctAnswer: 0,
            difficulty: .easy,
            explanation: "Isis was the great goddess of magic, healing, and motherhood."
        ),
        QuizQuestion(
            question: "What was the Old Kingdom known for?",
            options: ["Temples", "Pyramids", "Libraries", "Gardens"],
            correctAnswer: 1,
            difficulty: .easy,
            explanation: "The Old Kingdom (2686-2181 BCE) is famous for building the Great Pyramids of Giza."
        ),
        QuizQuestion(
            question: "Who was the falcon-headed sky god?",
            options: ["Ra", "Set", "Horus", "Ptah"],
            correctAnswer: 2,
            difficulty: .easy,
            explanation: "Horus, the falcon-headed god, was the protector of pharaohs and god of the sky."
        ),
        QuizQuestion(
            question: "Which goddess was depicted as a cat?",
            options: ["Isis", "Bastet", "Sekhmet", "Tefnut"],
            correctAnswer: 1,
            difficulty: .easy,
            explanation: "Bastet, the cat goddess, was the protector of homes and bringer of joy."
        ),
        QuizQuestion(
            question: "What river flows through Egypt?",
            options: ["Tigris", "Euphrates", "Nile", "Amazon"],
            correctAnswer: 2,
            difficulty: .easy,
            explanation: "The Nile River, the longest river in Africa, was the lifeblood of ancient Egypt."
        ),
        QuizQuestion(
            question: "What is the largest pyramid in Egypt?",
            options: ["Pyramid of Khafre", "Great Pyramid of Khufu", "Red Pyramid", "Bent Pyramid"],
            correctAnswer: 1,
            difficulty: .easy,
            explanation: "The Great Pyramid of Khufu at Giza is the largest, originally standing 146.5 meters tall."
        ),
        QuizQuestion(
            question: "What did ancient Egyptians use for writing?",
            options: ["Paper", "Stone tablets", "Papyrus", "Clay"],
            correctAnswer: 2,
            difficulty: .easy,
            explanation: "Papyrus, made from the papyrus plant, was used as ancient Egypt's paper."
        ),
        QuizQuestion(
            question: "What animals were sacred in ancient Egypt?",
            options: ["Dogs", "Cats", "Horses", "Camels"],
            correctAnswer: 1,
            difficulty: .easy,
            explanation: "Cats were sacred animals in ancient Egypt, associated with the goddess Bastet."
        )
    ]
    
    // MEDIUM QUESTIONS (Intermediate Level)
    static let mediumQuestions = [
        QuizQuestion(
            question: "Who became the ruler of the underworld after being resurrected?",
            options: ["Osiris", "Anubis", "Set", "Ra"],
            correctAnswer: 0,
            difficulty: .medium,
            explanation: "Osiris was murdered by Set but resurrected by Isis, becoming lord of the underworld."
        ),
        QuizQuestion(
            question: "Which period was the golden age of expansion?",
            options: ["Old Kingdom", "Middle Kingdom", "New Kingdom", "Late Period"],
            correctAnswer: 2,
            difficulty: .medium,
            explanation: "The New Kingdom (1550-1077 BCE) was Egypt's imperial age of maximum expansion."
        ),
        QuizQuestion(
            question: "Who was the first female pharaoh to rule in her own right?",
            options: ["Nefertiti", "Hatshepsut", "Cleopatra", "Nefertari"],
            correctAnswer: 1,
            difficulty: .medium,
            explanation: "Hatshepsut ruled as pharaoh for 22 years during the New Kingdom, wearing a false beard."
        ),
        QuizQuestion(
            question: "What was the purpose of the Book of the Dead?",
            options: ["Record history", "Guide souls in afterlife", "Tax records", "Medical knowledge"],
            correctAnswer: 1,
            difficulty: .medium,
            explanation: "The Book of the Dead contained spells and instructions to guide the deceased through the afterlife."
        ),
        QuizQuestion(
            question: "Who was the boy king whose tomb was found nearly intact?",
            options: ["Ramesses II", "Tutankhamun", "Akhenaten", "Khufu"],
            correctAnswer: 1,
            difficulty: .medium,
            explanation: "Tutankhamun's tomb was discovered by Howard Carter in 1922, filled with treasures."
        ),
        QuizQuestion(
            question: "What was Ma'at the goddess of?",
            options: ["War", "Truth and order", "Love", "Agriculture"],
            correctAnswer: 1,
            difficulty: .medium,
            explanation: "Ma'at represented truth, balance, order, and justice - fundamental to Egyptian society."
        ),
        QuizQuestion(
            question: "How long did the mummification process typically take?",
            options: ["7 days", "30 days", "70 days", "100 days"],
            correctAnswer: 2,
            difficulty: .medium,
            explanation: "Mummification took 70 days: 40 days to dry the body with natron, 30 days for wrapping and rituals."
        ),
        QuizQuestion(
            question: "Which pharaoh built the most temples and monuments?",
            options: ["Khufu", "Tutankhamun", "Ramesses II", "Akhenaten"],
            correctAnswer: 2,
            difficulty: .medium,
            explanation: "Ramesses II reigned for 66 years and built more temples and statues than any other pharaoh."
        ),
        QuizQuestion(
            question: "What were canopic jars used for?",
            options: ["Storing grain", "Holding water", "Storing organs", "Burning incense"],
            correctAnswer: 2,
            difficulty: .medium,
            explanation: "Canopic jars stored the deceased's organs (liver, lungs, stomach, intestines) during mummification."
        ),
        QuizQuestion(
            question: "Which city became the capital during the New Kingdom?",
            options: ["Memphis", "Thebes", "Alexandria", "Giza"],
            correctAnswer: 1,
            difficulty: .medium,
            explanation: "Thebes (modern Luxor) was the capital during the New Kingdom and home to Karnak Temple."
        ),
        QuizQuestion(
            question: "What was the Rosetta Stone used for?",
            options: ["Weapon", "Deciphering hieroglyphics", "Religious ceremony", "Building material"],
            correctAnswer: 1,
            difficulty: .medium,
            explanation: "The Rosetta Stone, with text in three scripts, was key to deciphering hieroglyphics in 1822."
        ),
        QuizQuestion(
            question: "Which god had the head of an ibis bird?",
            options: ["Horus", "Thoth", "Set", "Sobek"],
            correctAnswer: 1,
            difficulty: .medium,
            explanation: "Thoth, god of wisdom and writing, was depicted with an ibis head or as a baboon."
        )
    ]
    
    // HARD QUESTIONS (Expert Level)
    static let hardQuestions = [
        QuizQuestion(
            question: "Who deciphered hieroglyphics using the Rosetta Stone?",
            options: ["Howard Carter", "Jean-François Champollion", "Napoleon Bonaparte", "Flinders Petrie"],
            correctAnswer: 1,
            difficulty: .hard,
            explanation: "Jean-François Champollion deciphered hieroglyphics in 1822 after years studying the Rosetta Stone."
        ),
        QuizQuestion(
            question: "What was the capital of Egypt during the reign of Akhenaten?",
            options: ["Memphis", "Thebes", "Amarna", "Pi-Ramesses"],
            correctAnswer: 2,
            difficulty: .hard,
            explanation: "Akhenaten built a new capital called Akhetaten (modern Amarna) dedicated to the sun disk Aten."
        ),
        QuizQuestion(
            question: "Which battle did Ramesses II fight against the Hittites?",
            options: ["Battle of Megiddo", "Battle of Kadesh", "Battle of Pelusium", "Battle of Actium"],
            correctAnswer: 1,
            difficulty: .hard,
            explanation: "The Battle of Kadesh (1274 BCE) was one of history's first recorded battles, ending in a draw."
        ),
        QuizQuestion(
            question: "Who was the last native Egyptian pharaoh?",
            options: ["Cleopatra VII", "Nectanebo II", "Ptolemy I", "Ramesses XI"],
            correctAnswer: 1,
            difficulty: .hard,
            explanation: "Nectanebo II (360-343 BCE) was the last native Egyptian pharaoh before Persian conquest."
        ),
        QuizQuestion(
            question: "What was the name of Khufu's solar boat?",
            options: ["Barque of Ra", "Khufu Ship", "Solar Vessel", "Divine Boat"],
            correctAnswer: 1,
            difficulty: .hard,
            explanation: "The Khufu Ship, a 43.4-meter cedar vessel, was buried beside the Great Pyramid in 2500 BCE."
        ),
        QuizQuestion(
            question: "Which dynasty did Cleopatra VII belong to?",
            options: ["18th Dynasty", "19th Dynasty", "25th Dynasty", "Ptolemaic Dynasty"],
            correctAnswer: 3,
            difficulty: .hard,
            explanation: "Cleopatra VII was a Ptolemaic pharaoh, descendant of Alexander the Great's general Ptolemy."
        ),
        QuizQuestion(
            question: "What was the ancient Egyptian word for their black land?",
            options: ["Deshret", "Kemet", "Ta-Mery", "Iteru"],
            correctAnswer: 1,
            difficulty: .hard,
            explanation: "Kemet means 'black land,' referring to the fertile soil left by Nile floods. Desert was 'Deshret' (red land)."
        ),
        QuizQuestion(
            question: "Who built the first true pyramid?",
            options: ["Khufu", "Sneferu", "Djoser", "Khafre"],
            correctAnswer: 1,
            difficulty: .hard,
            explanation: "Sneferu built the first true smooth-sided pyramid at Dahshur after the failed Bent Pyramid."
        ),
        QuizQuestion(
            question: "What was the sea route to the land of Punt?",
            options: ["Mediterranean Sea", "Red Sea", "Persian Gulf", "Black Sea"],
            correctAnswer: 1,
            difficulty: .hard,
            explanation: "Ancient Egyptians sailed down the Red Sea to reach Punt (likely Somalia/Yemen) for incense and myrrh."
        ),
        QuizQuestion(
            question: "Which scribe god was said to have invented writing?",
            options: ["Ptah", "Thoth", "Seshat", "Imhotep"],
            correctAnswer: 1,
            difficulty: .hard,
            explanation: "Thoth was credited with inventing writing, mathematics, and science. Seshat was his female counterpart."
        ),
        QuizQuestion(
            question: "What was the primary material used to build pyramids?",
            options: ["Granite", "Limestone", "Sandstone", "Basalt"],
            correctAnswer: 1,
            difficulty: .hard,
            explanation: "Pyramids were built with local limestone blocks, with fine Tura limestone for outer casing."
        ),
        QuizQuestion(
            question: "Who was the architect of the Step Pyramid?",
            options: ["Amenhotep", "Imhotep", "Hemiunu", "Senenmut"],
            correctAnswer: 1,
            difficulty: .hard,
            explanation: "Imhotep designed the Step Pyramid for Djoser and was later deified as a god of medicine."
        )
    ]
    
    // All questions combined
    static let allQuestions = easyQuestions + mediumQuestions + hardQuestions
    
    // Get questions by difficulty
    static func questions(for difficulty: QuizDifficulty) -> [QuizQuestion] {
        switch difficulty {
        case .easy: return easyQuestions
        case .medium: return mediumQuestions
        case .hard: return hardQuestions
        }
    }
}

