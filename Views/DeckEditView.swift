//
//  DeckEditView.swift
//  MemoDash
//
//  Created by Umut on 1.06.2025.
//

import SwiftUI

struct DeckEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var deckTitle: String = ""
    @State private var newQuestion: String = ""
    @State private var newAnswer: String = ""
    @State private var addingStep: Int = 0 // 0: not adding, 1: question, 2: answer
    @FocusState private var isTextFieldFocused: Bool
    var deck: Deck
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Deck title editing section
                VStack(spacing: 12) {
                    TextField("Deck Title", text: $deckTitle)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .onSubmit {
                            saveDeckTitle()
                        }
                .onTapGesture {
                    // Cancel adding if user taps elsewhere
                    if addingStep > 0 {
                        cancelAddCard()
                    }
                }
                    
                    Text("\(deck.cards.count) cards")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                Divider()
                
                // Cards list
                List {
                    ForEach(Array(deck.cards.enumerated()), id: \.element.id) { index, card in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(card.question)
                                .font(.headline)
                            Text(card.answer)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteCard)
                    
                    // Add new card step-by-step
                    if addingStep == 1 {
                        TextField("Enter question", text: $newQuestion)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                if !newQuestion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    addingStep = 2
                                    isTextFieldFocused = true
                                }
                            }
                            .padding(.vertical, 8)
                    } else if addingStep == 2 {
                        VStack(spacing: 8) {
                            Text("Q: \(newQuestion)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TextField("Enter answer", text: $newAnswer)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .focused($isTextFieldFocused)
                                .onSubmit {
                                    addNewCard()
                                }
                        }
                        .padding(.vertical, 8)
                    } else {
                        Button(action: {
                            startAddingCard()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 20))
                                
                                Text("Add Card")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                                
                                Spacer()
                            }
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Edit Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveDeckTitle()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                deckTitle = deck.title
            }
        }
    }

    func deleteCard(at offsets: IndexSet) {
        for index in offsets {
            let card = deck.cards[index]
            modelContext.delete(card)
        }
        try? modelContext.save()
    }
    
    func saveDeckTitle() {
        if !deckTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            deck.title = deckTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            try? modelContext.save()
        }
    }
    
    func startAddingCard() {
        addingStep = 1
        newQuestion = ""
        newAnswer = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isTextFieldFocused = true
        }
    }
    
    func addNewCard() {
        if !newQuestion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
           !newAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let card = Flashcard(question: newQuestion.trimmingCharacters(in: .whitespacesAndNewlines),
                                answer: newAnswer.trimmingCharacters(in: .whitespacesAndNewlines))
            deck.cards.append(card)
            modelContext.insert(card)
            try? modelContext.save()
            
            // Reset
            newQuestion = ""
            newAnswer = ""
            addingStep = 0
        }
    }
    
    func cancelAddCard() {
        newQuestion = ""
        newAnswer = ""
        addingStep = 0
        isTextFieldFocused = false
    }
}

struct DeckEditView_Preview: PreviewProvider {
    static var previews: some View {
        let deck: Deck = Deck(title: "Sample Deck", cards: [
                Flashcard(question: "What is SwiftUI?", answer: "A modern UI framework by Apple."),
                Flashcard(question: "Where can I learn more about SwiftUI?", answer: "Apple's documentation and tutorials."),
                Flashcard(question: "Who is the creator of SwiftUI?", answer: "Apple Inc."),
                Flashcard(question: "What is the capital of France?", answer: "Paris"),
                Flashcard(question: "What is the capital of Germany?", answer: "Berlin"),
                Flashcard(question: "What is the capital of Italy?", answer: "Rome"),
                Flashcard(question: "What is the capital of Turkey?", answer: "Ankara"),
                Flashcard(question: "What is the capital of Turkey?", answer: "Ankara"),
                Flashcard(question: "What is the capital of Turkey?", answer: "Ankara"),
                Flashcard(question: "What is the capital of Turkey?", answer: "Ankara"),
                Flashcard(question: "What is the capital of Turkey?", answer: "Ankara"),
                Flashcard(question: "What is the capital of Turkey?", answer: "Ankara"),
                Flashcard(question: "What is the capital of Turkey?", answer: "Ankara"),
                Flashcard(question: "What is the capital of Brazil? Brazil is in LATAM region. They Speak Portuguese. They are very friendly. They love to eat feijoada. They have a lot of beaches. They are very good at soccer.", answer: "Brasília")
            ]
        )

        DeckEditView(deck: deck)
    }
}
