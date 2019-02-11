//
//  Deck.swift
//  Flash
//
//  Created by John Forde on 6/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

struct Deck: Equatable, Hashable, Codable {
	var title: String
	var cards: [Card] = []
	private var positionInDeck = 0

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
		//setupCards()
	}

	mutating func nextCard() -> Card {
		positionInDeck += 1
		if positionInDeck == cards.count {
				positionInDeck = 0
		}
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
