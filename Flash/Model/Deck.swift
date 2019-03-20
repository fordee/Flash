//
//  Deck.swift
//  Flash
//
//  Created by John Forde on 6/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit
//import CSV
//import SQLite



struct Deck: Equatable, Hashable, Codable {
	var title: String
	var frontLanguage: String?
	var backLanguage: String?


	var cards: [Card] = []
	private var positionInDeck = 0

	var currentCard: Card {
		return cards[positionInDeck]
	}

//	static func setupDeckTable() {
//		do {
//			let db = try Connection(Connection.Location.uri("Documents"), readonly: false)
//
//			let deck = Table("deck")
//			let id = Expression<Int64>("id")
//			let title = Expression<String>("title")
//
//			try db.run(deck.create { t in
//				t.column(id, primaryKey: true)
//				t.column(title)
//			})
//		} catch {
//			print("Error during database operation: \(error.localizedDescription)")
//		}
//	}

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

//	init(deckFileName: String) {
//		title = "csv"
//
//		guard let path = Bundle.main.path(forResource: deckFileName, ofType: nil) else { return }
//		let url = URL(fileURLWithPath: path)
//
//		do {
//			let data = try Data(contentsOf: url)
//			let decoder = CSVDecoder()
//			decoder.delimiters = (.comma, .carriageReturn)
//			let result = try decoder.decode([[String]].self, from: data)
//			//print(result)
//			title = "JLTP 2 Vocab"
//
//			for line in result {
//				let frontWord: String
//				let backWord: String
//				if line[2] == "" {
//					frontWord = line[1]
//					backWord = line[3] + "\n" + line[4]
//				} else {
//					frontWord = line[2]
//					backWord = line[1] + "\n" + line[3] + "\n" + line[4]
//				}
//
//				let card = Card(backgroundColor: Color.random(), frontWord: frontWord, backWord: backWord)
//				cards.append(card)
//			}
//			print("finished.")
//		}
//		catch {
//			fatalError("Error reading JLPT2Vocab.csv")
//		}
//
//	}

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

	private mutating func setupCards() {
		cards.append(Card(backgroundColor: Color(color: .red), frontWord: "向", backWord: "む.く、む.い\nコウ\ntoward, direction"))
		cards.append(Card(backgroundColor: Color(color: .magenta), frontWord: "かける", backWord: "to put on"))
		cards.append(Card(backgroundColor: Color(color: .blue), frontWord: "予", backWord: "ヨ\nprediction"))
		cards.append(Card(backgroundColor: Color(color: .cyan), frontWord: "必要", backWord: "ひつよう\nnecessary"))
		cards.append(Card(backgroundColor: Color(color: .green), frontWord: "従う", backWord: "したがう\nobey"))
		cards.append(Card(backgroundColor: Color(color: .brown), frontWord: "減少", backWord: "げんしょう\ndecrease, reduction"))
		cards.append(Card(backgroundColor: Color(color: .darkGray), frontWord: "歯ごたえ", backWord: "はごたえ\nchewy"))
		cards.append(Card(backgroundColor: Color(color: .purple), frontWord: "必ず", backWord: "かならず\nwithout fail"))
		cards.append(Card(backgroundColor: Color(color: UIColor(red: 253/255, green: 1/255, blue: 75/255, alpha: 1)), frontWord: "打つ", backWord: "うつ\nstrike, hit"))
		cards.append(Card(backgroundColor: Color(color: UIColor(red: 120/255, green: 122/255, blue: 255/255, alpha: 1)), frontWord: "欠", backWord: "か.ける、か.く\nケツ、ケン\nlack, gap, fail"))
	}

}
