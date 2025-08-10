//
//  NewDeckView.swift
//  MemoDash
//
//  Created by Umut on 4.05.2025.
//

import SwiftUI

struct NewDeckView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var deckTitle: String = ""
    
    var onSave: (Deck) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Deck Title"), footer: Text("Collection of cards will be named as this")) {
                    TextField("Enter title", text: $deckTitle)
                }
            }
            .navigationTitle("New Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newDeck = Deck(title: deckTitle.trimmingCharacters(in: .whitespacesAndNewlines), cards: [])
                        onSave(newDeck)
                        dismiss()
                    }
                    .disabled(deckTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct NewDeckView_Preview: PreviewProvider {
    static var previews: some View {
        NewDeckView(onSave: { _ in })
    }
}
