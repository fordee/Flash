//
//  FlashCard.swift
//  Flash
//
//  Created by John Forde on 6/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

struct Card {
	let backgroundColor: UIColor
	let frontWord: String
	let backWord: String

	init(backgroundColor: UIColor, frontWord: String, backWord: String) {
		self.backgroundColor = backgroundColor
		self.frontWord = frontWord
		self.backWord = backWord
	}
}
