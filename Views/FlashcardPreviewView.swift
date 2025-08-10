//
//  FlashcardPreviewView.swift
//  MemoDash
//
//  Created by Umut on 4.05.2025.
//

import SwiftUI

struct FlashcardPreviewView: View {
    let card: Flashcard
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(card.question)
                .font(.title3)
                .fontWeight(.semibold)
            Divider()
            Text(card.answer)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colorScheme == .dark ? Color.purple.opacity(0.3) : Color.purple.opacity(0.1),
                            colorScheme == .dark ? Color.blue.opacity(0.3) : Color.blue.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .padding(.vertical, 6)
    }
}


struct FlashcardPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardPreviewView(card: .init(question: "Question", answer: "Answer"))
            .previewLayout(.sizeThatFits)
    }
}
