//
//  HomeView.swift
//  MemoDash
//
//  Created by Umut on 2.05.2025.
//

import SwiftUI
import SwiftData

// DeckRowView displays a single deck row with count, title, creation date, and chevron.
struct DeckRowView: View {
    let deck: Deck

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Text("\(deck.cards.count)")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(deck.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Created on \(deck.createdAt.formatted(.dateTime.month().day()))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            }
        .padding(.vertical, 8)
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var decks: [Deck]

    @State private var showAddDeck: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(decks) { deck in
                        NavigationLink(destination: DeckDetailView(deck: deck)) {
                            DeckRowView(deck: deck)
                        }
                        .roundedBackground()
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deleteDecks)
                }
            }
            .listStyle(.plain)
            .navigationTitle("My Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddDeck = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.blue)
                            .shadow(color: Color.blue.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
            }
            .sheet(isPresented: $showAddDeck) {
                NewDeckView { newDeck in
                    modelContext.insert(newDeck)
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }

    private func deleteDecks(at offsets: IndexSet) {
        for index in offsets {
            let deck = decks[index]
            modelContext.delete(deck)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .modelContainer(for: Deck.self, inMemory: true)
    }
}


// Custom view modifier for rounded list row background
extension View {
    func roundedBackground() -> some View {
        self.listRowBackground(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.secondarySystemBackground))
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
        )
    }
}
