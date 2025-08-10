//
//  Deck.swift
//  MemoDash
//
//  Created by Umut on 2.05.2025.
//

import Foundation
import SwiftData

@Model
class Deck: Identifiable {
    var title: String
    var cards: [Flashcard]
    var createdAt: Date = Date()
    
    init(title: String, cards: [Flashcard] = [], createdAt: Date = Date()) {
        self.title = title
        self.cards = cards
        self.createdAt = createdAt
    }
}
