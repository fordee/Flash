//
//  FlashCard.swift
//  Flash
//
//  Created by John Forde on 6/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit
import SQLite

struct Card: Equatable, Hashable, Codable {
	var id: Int64?
	let backgroundColor: Color
	var frontWord: String
	var backWord: String

	init(id: Int64? = nil, backgroundColor: Color, frontWord: String, backWord: String) {
		self.id = id
		self.backgroundColor = backgroundColor
		self.frontWord = frontWord
		self.backWord = backWord
	}

	mutating func add(deck: Deck) {
		do {
			guard let db = Database.getDbConnection() else { return }
			let card = Table("card")

			let deckIdColumn = Expression<Int64>("deck_id")
			let frontWordColumn = Expression<String?>("front_word")
			let backWordColumn = Expression<String?>("back_word")
			let backgroundColorColumn = Expression<String>("background_color")

			guard let deckId = getDeckId(for: deck) else { return }

			let rowid = try db.run(card.insert(deckIdColumn <- deckId, frontWordColumn <- frontWord, backWordColumn <- backWord, backgroundColorColumn <- backgroundColor.color))
			id = rowid
			print("inserted id: \(rowid), deck id: \(deckId)")
		} catch {
			print("insertion failed: \(error)")
		}
	}

	func update(deck: Deck) {
		do {
			guard let db = Database.getDbConnection() else { return }
			let cardTable = Table("card")

			let deckIdColumn = Expression<Int64>("deck_id")
			let frontWordColumn = Expression<String?>("front_word")
			let backWordColumn = Expression<String?>("back_word")
			let backgroundColorColumn = Expression<String>("background_color")

			guard let deckId = getDeckId(for: deck) else { return }

			let cardFiltered = cardTable.filter(deckIdColumn == deckId && frontWordColumn == frontWord)

			let rowid = try db.run(cardFiltered.update(frontWordColumn <- frontWord, backWordColumn <- backWord, backgroundColorColumn <- backgroundColor.color))
			print("updated id: \(rowid)")
		} catch {
			print("update failed: \(error)")
		}
	}

	func delete(deck: Deck) {
		do {
			guard let db = Database.getDbConnection() else { return }
			let cardTable = Table("card")

			let deckIdColumn = Expression<Int64>("deck_id")
			let frontWordColumn = Expression<String?>("front_word")

			guard let deckId = getDeckId(for: deck) else { return }

			let cardFiltered = cardTable.filter(deckIdColumn == deckId && frontWordColumn == frontWord)

			try db.run(cardFiltered.delete())
			print("delete suceeded")

		} catch {
			print("delete failed: \(error)")
		}
		
	}

	private func getDeckId(for deck: Deck) -> Int64? {
		do {
			guard let db = Database.getDbConnection() else { return nil }
			let deckTable = Table("deck")
			let id = Expression<Int64>("id")
			let title = Expression<String>("title")

			let filteredDeck = deckTable.filter(title == deck.title)
			// Should only be one row because title is unique
			if let row = try db.pluck(filteredDeck) {
				return row[id]
			} else {
				return nil
			}
		} catch {
			print("Error during database operation: \(error.localizedDescription)")
		}
		return nil
	}
}



