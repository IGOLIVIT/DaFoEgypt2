//
//  EgyptianGod.swift
//  DaFoEgypt2
//
//  Created by IGOR on 24/10/2025.
//

import Foundation

struct EgyptianGod: Identifiable {
    let id = UUID()
    let name: String
    let title: String
    let description: String
    let symbol: String
    let iconName: String
}

extension EgyptianGod {
    static let gods = [
        EgyptianGod(
            name: "Ra",
            title: "Sun God and Creator",
            description: "Ra, the mighty sun god, sailed across the sky each day in his solar barque, bringing light and warmth to the world. He was the supreme deity of creation, the father of all gods, and the embodiment of divine kingship.",
            symbol: "☀️",
            iconName: "sun.max.fill"
        ),
        EgyptianGod(
            name: "Anubis",
            title: "Guardian of the Dead",
            description: "Anubis, the jackal-headed god, was the guardian of the dead and master of mummification. He weighed the heart of the deceased against the feather of Ma'at, determining who was worthy of entering the afterlife.",
            symbol: "⚖️",
            iconName: "figure.stand"
        ),
        EgyptianGod(
            name: "Isis",
            title: "Goddess of Magic and Motherhood",
            description: "Isis was the great goddess of magic, healing, and motherhood. She used her powerful magic to resurrect Osiris and protect their son Horus. She was revered as the ideal mother and wife throughout Egypt.",
            symbol: "✨",
            iconName: "star.fill"
        ),
        EgyptianGod(
            name: "Osiris",
            title: "Lord of the Underworld",
            description: "Osiris, the first pharaoh, was murdered by his brother Set but resurrected by Isis. He became the ruler of the underworld and judge of the dead, offering eternal life to those who lived justly.",
            symbol: "🌾",
            iconName: "leaf.fill"
        ),
        EgyptianGod(
            name: "Horus",
            title: "Sky God and Divine Protector",
            description: "Horus, the falcon-headed god, was the son of Isis and Osiris. He avenged his father's death and became the protector of pharaohs. His eyes represented the sun and moon, watching over all of Egypt.",
            symbol: "🦅",
            iconName: "bird.fill"
        ),
        EgyptianGod(
            name: "Bastet",
            title: "Goddess of Protection and Joy",
            description: "Bastet, the cat goddess, was the protector of homes and bringer of joy. She warded off evil spirits and disease, and was celebrated with music, dance, and festivals throughout the land.",
            symbol: "🐱",
            iconName: "pawprint.fill"
        )
    ]
}

