//
//  Deck.swift
//  Flash
//
//  Created by John Forde on 6/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit
//import CSV
import SQLite



struct Deck: Equatable, Hashable, Codable {
	var id: Int64?
	var title: String
	var frontLanguage: String?
	var backLanguage: String?

	private var selected: Bool = false

	private var cards: [Card] = []
	private var positionInDeck = 0

	var allCards: [Card] {
		return cards
	}

	var currentCard: Card {
		return cards[positionInDeck]
	}

	var previousCard: Card {
		if positionInDeck == 0 {
			return cards[cards.count - 1]
		} else {
			return cards[positionInDeck - 1]
		}
	}

	init(title: String) {
		self.title = title
	}

	init(id: Int64, title: String, frontLanguage: String?, backLanguage: String?, selected: Bool) {
		self.id = id
		self.title = title
		self.frontLanguage = frontLanguage
		self.backLanguage = backLanguage
		self.selected = selected
	}

	mutating func setCards(_ cards: [Card]) {
		self.cards = cards
	}

	func add() {
		do {
			guard let db = Database.getDbConnection() else { return }
			let deck = Table("deck")
			let titleColumn = Expression<String>("title")
			let frontLanguageColumn = Expression<String?>("front_language")
			let backLanguageColumn = Expression<String?>("back_language")
			let selectedColumn = Expression<Bool>("selected")

			let rowid = try db.run(deck.insert(titleColumn <- title, frontLanguageColumn <- frontLanguage, backLanguageColumn <- backLanguage, selectedColumn <- selected))
			print("inserted id: \(rowid)")
		} catch {
			print("insertion failed: \(error)")
		}
	}

	func update() {
		do {
			guard let db = Database.getDbConnection() else { return }
			let deck = Table("deck")
			let idColumn = Expression<Int64>("id")
			let titleColumn = Expression<String>("title")
			let frontLanguageColumn = Expression<String?>("front_language")
			let backLanguageColumn = Expression<String?>("back_language")
			let selectedColumn = Expression<Bool>("selected")

			guard let deckId = id else { return }

			let deckFiltered = deck.filter(idColumn == deckId)
			try db.run(deckFiltered.update(titleColumn <- title, frontLanguageColumn <- frontLanguage, backLanguageColumn <- backLanguage, selectedColumn <- selected))
			print("update id: \(deckId)")
		} catch {
			print("insertion failed: \(error)")
		}
	}

	func delete() {
		do {
			guard let db = Database.getDbConnection() else { return }
			let deck = Table("deck")
			let idColumn = Expression<Int64>("id")

			guard let deckId = id else { return }

			let deckFiltered = deck.filter(idColumn == deckId)
			try db.run(deckFiltered.delete())
			print("delete suceeded")
		} catch {
			print("delete failed: \(error)")
		}
	}


	mutating func select() {
		selected = true
		update()
	}

	mutating func deselect() {
		selected = false
		update()
	}

	var isSelected: Bool {
		return selected
	}

	mutating func shuffle() {
		cards.shuffle()
	}

	mutating func nextCard() -> Card {
		positionInDeck += 1
		if positionInDeck == cards.count {
			positionInDeck = 0
		}
		print("Next Card called. positionInDeck: \(positionInDeck)")
		return cards[positionInDeck]
	}

}
