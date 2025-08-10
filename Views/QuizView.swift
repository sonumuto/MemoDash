//
//  QuizView.swift
//  MemoDash
//
//  Created by Umut on 3.05.2025.
//

import SwiftUI

struct QuizView: View {
    var deck: Deck
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentIndex = 0
    @State private var showAnswer = false
    @State private var offset = CGSize.zero
    @State private var shuffledCards: [Flashcard]
    
    init(deck: Deck) {
        self.deck = deck
        _shuffledCards = State(initialValue: deck.cards.shuffled())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    // Progress indicator
                    HStack {
                        Text("\(currentIndex + 1) / \(shuffledCards.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ProgressView(value: Double(currentIndex + 1), total: Double(shuffledCards.count))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // Card view
                    if currentIndex < shuffledCards.count {
                        ZStack {
                            // Current card
                            currentCardView
                        }
                    }
                    
                    Spacer()
                    
                    // Control buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showAnswer.toggle()
                            }
                        }) {
                            Image(systemName: showAnswer ? "eye.slash" : "eye")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .background(Circle().fill(Color.blue.opacity(0.1)))
                        }
                        
                        Button(action: {
                            nextCard()
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.title2)
                                .foregroundColor(.green)
                                .frame(width: 50, height: 50)
                                .background(Circle().fill(Color.green.opacity(0.1)))
                        }
                        .disabled(currentIndex >= shuffledCards.count - 1)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Quiz: \(deck.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: currentIndex) { _, _ in
            showAnswer = false
        }
    }
    
    private var currentCardView: some View {
        let currentCard = shuffledCards[currentIndex]

        return cardView(for: currentCard, isCurrentCard: true)
            .offset(offset)
            .gesture(cardDragGesture)
    }
    
    @ViewBuilder
    private func cardView(for card: Flashcard, isCurrentCard: Bool) -> some View {
        ZStack {
            // Card flip animation
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    showAnswer
                        ? AnyShapeStyle(colorScheme == .dark
                            ? Color(red: 0.05, green: 0.05, blue: 0.2)
                            : Color.white)
                        : AnyShapeStyle(LinearGradient(
                            gradient: Gradient(colors: [
                                colorScheme == .dark ? Color.purple.opacity(0.3) : Color.purple.opacity(0.8),
                                colorScheme == .dark ? Color.blue.opacity(0.3) : Color.blue.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
            
            // Front side (Question)
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    Text("Question")
                        .font(.caption)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.white)
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    Text(card.question)
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.white)
                }
                
            }
            .opacity(showAnswer ? 0 : 1)
            .animation(nil, value: showAnswer)
            
            // Back side (Answer) - only for current card
            if isCurrentCard {
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        Text("Answer")
                            .font(.caption)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.secondary)
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        Text(card.answer)
                            .font(.title)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.primary)
                    }
                }
                .padding(30)
                .opacity(showAnswer ? 1 : 0)
                .animation(nil, value: showAnswer)
                .scaleEffect(x: -1, y: 1)
            }
        }
        .rotation3DEffect(
            .degrees(showAnswer ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .frame(maxWidth: .infinity)
        .frame(height: 450)
        .padding(.horizontal, 20)
    }
    
    private var cardDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { value in
                let threshold: CGFloat = 80
                let screenHeight = UIScreen.main.bounds.height
                
                // Horizontal swipe: flip card
                if abs(value.translation.width) > threshold && abs(value.translation.width) > abs(value.translation.height) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showAnswer.toggle()
                        offset = .zero
                    }
                }
                // Vertical swipe: dismiss and toss next from top
                else if abs(value.translation.height) > threshold && abs(value.translation.height) > abs(value.translation.width) {
                    let dismissY = value.translation.height > 0 ? screenHeight : -screenHeight
                    withAnimation(.easeInOut(duration: 0.2)) {
                        offset = CGSize(width: 0, height: dismissY)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if currentIndex < shuffledCards.count - 1 {
                            currentIndex += 1
                            showAnswer = false
                            // Start next card above screen
                            offset = CGSize(width: 0, height: -screenHeight)
                            withAnimation(.easeInOut(duration: 0.2)) {
                                offset = .zero
                            }
                        } else {
                            dismiss()
                        }
                    }
                }
                // Insufficient drag: reset
                else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        offset = .zero
                    }
                }
            }
    }
    
    private func nextCard() {
        let screenHeight = UIScreen.main.bounds.height
        withAnimation(.easeInOut(duration: 0.2)) {
            offset = CGSize(width: 0, height: -screenHeight)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if currentIndex < shuffledCards.count - 1 {
                currentIndex += 1
                showAnswer = false
                offset = CGSize(width: 0, height: -screenHeight)
                withAnimation(.easeInOut(duration: 0.2)) {
                    offset = .zero
                }
            } else {
                dismiss()
            }
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        let deck: Deck = Deck(title: "Sample Quiz", cards: [
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

        QuizView(deck: deck)
    }
}
