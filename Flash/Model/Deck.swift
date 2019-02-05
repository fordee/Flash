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
		if positionInDeck == cards.count {
			positionInDeck = 0
		}
		defer {
			positionInDeck += 1
		}
		return cards[positionInDeck]
	}

	private mutating func setupCards() {
		cards.append(Card(backgroundColor: .red))
		cards.append(Card(backgroundColor: .blue))
		cards.append(Card(backgroundColor: .cyan))
		cards.append(Card(backgroundColor: .green))
		cards.append(Card(backgroundColor: .brown))
		cards.append(Card(backgroundColor: .darkGray))
		cards.append(Card(backgroundColor: .purple))
		cards.append(Card(backgroundColor: UIColor(red: 253/255, green: 1/255, blue: 75/255, alpha: 1)))
		cards.append(Card(backgroundColor: UIColor(red: 120/255, green: 122/255, blue: 255/255, alpha: 1)))
	}

}
