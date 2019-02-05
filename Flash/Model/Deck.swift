//
//  Deck.swift
//  Flash
//
//  Created by John Forde on 6/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

struct Deck {
	var cards: [Card] = []
	var positionInDeck = 0

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

	init() {
		setupCards()
	}


	mutating func nextCard() -> Card {
		defer {
			positionInDeck += 1
			if positionInDeck == cards.count { // Can't allow positionIndeck to ever be invalid.
				positionInDeck = 0
			}
		}
		return cards[positionInDeck]
	}

	private mutating func setupCards() {
		cards.append(Card(backgroundColor: .red, frontWord: "かける", backWord: "to put on"))
		cards.append(Card(backgroundColor: .blue, frontWord: "予", backWord: "prediction"))
		cards.append(Card(backgroundColor: .cyan, frontWord: "必要", backWord: "necessary"))
		cards.append(Card(backgroundColor: .green, frontWord: "從う", backWord: "obey"))
		cards.append(Card(backgroundColor: .brown, frontWord: "減少", backWord: "decrease, reduction"))
		cards.append(Card(backgroundColor: .darkGray, frontWord: "歯ごたえ", backWord: "chewy"))
		cards.append(Card(backgroundColor: .purple, frontWord: "必ず", backWord: "without fail"))
		cards.append(Card(backgroundColor: UIColor(red: 253/255, green: 1/255, blue: 75/255, alpha: 1), frontWord: "打つ", backWord: "strike, hit"))
		cards.append(Card(backgroundColor: UIColor(red: 120/255, green: 122/255, blue: 255/255, alpha: 1), frontWord: "欠", backWord: "lack, gap, fail"))
	}

}
