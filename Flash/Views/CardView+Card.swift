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
		backgroundColor = card.backgroundColor.uiColor

		let brightness = backgroundColor!.brightness
		//print("Brightness: \(brightness)")
		let contrastColor = brightness > 0.75 ? UIColor.black : UIColor.white
		frontLabel.textColor = contrastColor

		let image = soundButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
		soundButton.setImage(image, for: .normal)
		soundButton.imageView?.tintColor = contrastColor

		if isAnswerCard {
			let backWord = card.backWord.replacingOccurrences(of: ", ", with: ",\n")
			frontLabel.text = backWord
		} else {
			frontLabel.text = card.frontWord
		}
	}
}

