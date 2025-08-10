//
//  DeckDetailView.swift
//  MemoDash
//
//  Created by Umut on 3.05.2025.
//

import SwiftUI

struct DeckDetailView: View {
    var deck: Deck
    @Environment(\.modelContext) private var modelContext
    @State private var showDeckEditView = false
    @State private var showQuizView = false
    @State private var gradientShift: CGFloat = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                if deck.cards.isEmpty {
                    Spacer()
                    Text("This deck is empty.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Button("Add") {
                        showDeckEditView = true
                    }
                    .foregroundColor(.blue)
                    .buttonStyle(PlainButtonStyle())
                    .fontWeight(.medium)
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(deck.cards) { card in
                            FlashcardPreviewView(card: card)
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        gradientShift += 0.2
                    }
                    // Start quiz
                    showQuizView = true
                }) {
                    Text("Start")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: UnitPoint(x: 0.0 + gradientShift, y: 0.5),
                                endPoint: UnitPoint(x: 1.0 + gradientShift, y: 0.5)
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
                .contentShape(Rectangle())
                .padding([.horizontal, .bottom])
                .disabled(deck.cards.isEmpty)
            }
            .navigationTitle(deck.title)
            .sheet(isPresented: $showDeckEditView) {
                DeckEditView(deck: deck)
            }
            .fullScreenCover(isPresented: $showQuizView) {
                QuizView(deck: deck)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDeckEditView = true
                    }) {
                        Text("Edit")
                    }
                }
            }
        }
    }
}

struct DeckDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let deck: Deck = Deck(title: "Sample Deck", cards: [
                Flashcard(question: "What is SwiftUI?", answer: "A modern UI framework by Apple."),
                Flashcard(question: "Where can I learn more about SwiftUI?", answer: "Apple's documentation and tutorials."),
                Flashcard(question: "Who is the creator of SwiftUI?", answer: "Apple Inc."),
                Flashcard(question: "What is the capital of France?", answer: "Paris"),
                Flashcard(question: "What is the capital of Germany?", answer: "Berlin"),
                Flashcard(question: "What is the capital of Italy?", answer: "Rome"),
                Flashcard(question: "What is the capital of Turkey?", answer: "Ankara"),
                Flashcard(question: "What is the capital of Brazil? Brazil is in LATAM region. They Speak Portuguese. They are very friendly. They love to eat feijoada. They have a lot of beaches. They are very good at soccer.", answer: "Brasília")
            ]
        )

        DeckDetailView(deck: deck)
    }
}
