//
//  Database.swift
//  Flash
//
//  Created by John Forde on 24/03/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import Foundation
import SQLite

class Database {

	static var collection: Collection = Collection()
	
	static func setupDatabase() {

		//dropAllTables()

		if let deck = setupDeckTable() {
			setupCardTable(deck: deck)
		}
		//setupDummyData()
	}

	static func getDbConnection() -> Connection? {
		let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
		do {
			let db = try Connection("\(path)/db.sqlite3")
			return db
		} catch {
			print("Error during database operation: \(error.localizedDescription)")
		}
		return nil
	}

	static func setupDummyData() {
		do {
			guard let db = getDbConnection() else { print("Can't get database handle"); return }
			let deck = Table("deck")
			let title = Expression<String>("title")

			let rowid = try db.run(deck.insert(title <- "JLPT Level 2 (vocab)"))
			print("inserted id: \(rowid)")
		} catch {
			print("insertion failed: \(error)")
		}
	}

	static func dropAllTables() {
		do {
			guard let db = getDbConnection() else { print("Can't get database handle"); return }
			let deck = Table("deck")
			let card = Table("card")

			try db.run(deck.drop())
			try db.run(card.drop())
		} catch {
			print("Error during database operation: \(error.localizedDescription)")
		}
	}

	static func setupDeckTable() -> Table? {
		do {
			guard let db = getDbConnection() else { print("Can't get database handle"); return nil }

			let deck = Table("deck")
			let id = Expression<Int64>("id")
			let title = Expression<String>("title")
			let frontLanguage = Expression<String?>("front_language")
			let backLanguage = Expression<String?>("back_language")
			let selected = Expression<Bool>("selected")

			try db.run(deck.create(ifNotExists: true) { t in
				t.column(id, primaryKey: .autoincrement)
				t.column(title, unique: true)
				t.column(frontLanguage)
				t.column(backLanguage)
				t.column(selected, defaultValue: false)
			})

			return deck

		} catch {
			print("Error during database operation: \(error.localizedDescription)")
		}
		return nil
	}

	static func setupCardTable(deck: Table) {
		do {
			guard let db = getDbConnection() else { print("Can't get database handle"); return }

			let card = Table("card")
			let id = Expression<Int64>("id")
			let deckId = Expression<Int64>("deck_id")
			let frontWord = Expression<String>("front_word")
			let backWord = Expression<String?>("back_word")
			let backgroundColor = Expression<String?>("background_color")


			try db.run(card.create(ifNotExists: true) { t in
				t.column(id, primaryKey: .autoincrement)
				t.column(deckId, references: deck, id)
				t.column(frontWord)
				t.column(backWord)
				t.column(backgroundColor)
				t.unique(frontWord, deckId)
			})
		} catch {
			print("Error during database operation: \(error.localizedDescription)")
		}
	}

	static func selectAllDecks() -> [Deck] {
		var decks: [Deck] = []
		do {
			guard let db = getDbConnection() else { print("Can't get database handle"); return decks }

			let deckTable = Table("deck")

			let id = Expression<Int64>("id")
			let title = Expression<String>("title")
			let frontLanguage = Expression<String?>("front_language")
			let backLanguage = Expression<String?>("back_language")
			let selected = Expression<Bool>("selected")

			for deckRow in try db.prepare(deckTable) {
				let deck = Deck(id: deckRow[id], title: deckRow[title], frontLanguage: deckRow[frontLanguage], backLanguage: deckRow[backLanguage], selected: deckRow[selected])
				decks.append(deck)
				print("id: \(deckRow[id]), title: \(deckRow[title]), frontLanguage: \(deckRow[frontLanguage] ?? ""), backLanguage: \(deckRow[backLanguage] ?? "" ) selected: \(deckRow[selected])")
			}
		} catch {
			print("Error during database operation: \(error.localizedDescription)")
		}
		return decks
	}

	static func selectAllCards(for deck: Deck) -> [Card] {
		var cards: [Card] = []
		do {
			guard let db = getDbConnection() else { print("Can't get database handle"); return cards }

			let cardTable = Table("card")

			let id = Expression<Int64>("id")
			let deckId = Expression<Int64>("deck_id")
			let frontWord = Expression<String>("front_word")
			let backWord = Expression<String?>("back_word")
			let backgroundColor = Expression<String?>("background_color")

			if let forDeckId = deck.id {
				let filteredTable = cardTable.filter(deckId == forDeckId)
				for cardRow in try db.prepare(filteredTable) {
					let card = Card(id: cardRow[id], backgroundColor: Color(hexString: cardRow[backgroundColor] ?? "FFFFFF"), frontWord: cardRow[frontWord], backWord: cardRow[backWord] ?? "")
					cards.append(card)
					//print("id: \(cardRow[id]), deckId: \(cardRow[deckId]), frontWord: \(cardRow[frontWord]), backWord: \(cardRow[backWord] ?? "") backgroundColor: \(cardRow[backgroundColor] ?? "")")
				}
			}
		} catch {
			print("Error during database operation: \(error.localizedDescription)")
		}
		return cards
	}

}
