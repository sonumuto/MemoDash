//
//  NewCardView.swift
//  MemoDash
//
//  Created by Umut on 10.05.2025.
//

import SwiftUI

struct NewCardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var cardQuestion: String = ""
    @State private var cardAnswer: String = ""
    
    var onSave: (Flashcard) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Question"), footer: Text("Front side of the FlashCard.")) {
                    TextField("Enter question", text: $cardQuestion)
                }
                Section(header: Text("Answer"), footer: Text("Back side of the FlashCard.")) {
                    TextField("Enter answer", text: $cardAnswer)
                }
                
            }
            .navigationTitle("New Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedQuestion = cardQuestion.trimmingCharacters(in: .whitespacesAndNewlines)
                        let trimmedAnswer = cardAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
                        let newCard = Flashcard(question: trimmedQuestion, answer: trimmedAnswer)
                        onSave(newCard)
                        dismiss()
                    }
                    .disabled(cardQuestion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && cardAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct NewCardView_Preview: PreviewProvider {
    static var previews: some View {
        NewCardView(onSave: { _ in })
    }
}
