//
//  FlashCard.swift
//  Flash
//
//  Created by John Forde on 6/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

struct Card: Equatable, Hashable, Codable {
	let backgroundColor: Color
	var frontWord: String
	var backWord: String

	init(backgroundColor: Color, frontWord: String, backWord: String) {
		self.backgroundColor = backgroundColor
		self.frontWord = frontWord
		self.backWord = backWord
	}
}



