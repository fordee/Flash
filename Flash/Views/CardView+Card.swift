//
//  CardView+Card.swift
//  Flash
//
//  Created by John Forde on 6/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

extension CardView {

	func render(with card: Card) {
		backgroundColor = card.backgroundColor

		let brightness = card.backgroundColor.brightness
		//print("Brightness: \(brightness)")
		frontLabel.textColor = brightness > 0.75 ? UIColor.black : UIColor.white
		if isAnswerCard {
			frontLabel.text = card.backWord
		} else {
			frontLabel.text = card.frontWord
		}
	}
}

