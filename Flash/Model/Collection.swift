//
//  Collection.swift
//  Flash
//
//  Created by John Forde on 10/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import Foundation

struct Collection: Equatable, Hashable, Codable {
	private var decks: [Deck] = []
	private let fileUrl = FileManager.default.urlFor(filePath: "deckCollection.json")

	var allDecks: [Deck] {
		return decks
	}

	init(_ decks: [Deck]) {
		self.decks = decks
	}

	init() {
//		if !FileManager.default.fileExists(atPath: fileUrl!.path) {
//			return
//		}
//		do {
//			guard let url = fileUrl else { return }
//			let jsonString = try Data(contentsOf: url)
//			let jsonDecoder = JSONDecoder()
//			decks = try jsonDecoder.decode([Deck].self, from: jsonString)
//		}
//		catch let error{
//			//fatalError("Error reading deckCollection.json")
//			print("Error reading deckCollection.json \(error)")
//		}
		decks = Database.selectAllDecks()

		for index in 0..<decks.count {
			let cards = Database.selectAllCards(for: decks[index])
			decks[index].setCards(cards)
		}
		
	}

	func deck(at index: Int) -> Deck {
		return decks[index]
	}

	mutating func removeDeck(at index: Int) {
		let deck = decks[index]
		deck.delete()
		decks.remove(at: index)
	}

	mutating func addDeck(deck: Deck) {
		decks.append(deck)
		deck.add()
	}

	mutating func updateDeck(_ deck: Deck, at index: Int) {
		decks[index] = deck
		deck.update()
	}

	mutating func setCards(_ cards: [Card], atDeckIndex: Int) {
		decks[atDeckIndex].setCards(cards)
	}

	func selectedDeck() -> Deck? {
		for deck in decks {
			if deck.isSelected {
				return deck
			}
		}
		return decks.first
	}

	mutating func selectDeck(at index: Int) {
		for i in 0..<decks.count {
			if i == index {
				decks[i].select()
			} else {
				decks[i].deselect()
			}
		}

	}

	func saveToDatabase() {
		for deck in decks {
			deck.add()
			for card in deck.allCards {
				card.add(deck: deck)
			}
		}
	}

//	func save() {
//		guard let url = fileUrl, let encodedObject = try? JSONEncoder().encode(decks) else { return }
//		if let encodedObjectJsonString = String(data: encodedObject, encoding: .utf8)
//		{
//			print(encodedObjectJsonString)
//			do {
//				try encodedObjectJsonString.write(to: url, atomically: true, encoding: .utf8)
//			} catch {
//				fatalError("Error saving deckCollection.json")
//			}
//		}
//	}
}
