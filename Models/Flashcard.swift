//
//  Flashcard.swift
//  MemoDash
//
//  Created by Umut on 3.05.2025.
//

import Foundation
import SwiftData

@Model
class Flashcard: Identifiable {
    var question: String
    var answer: String
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
}
