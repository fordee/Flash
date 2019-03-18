//
//  CardView.swift
//  Flash
//
//  Created by John Forde on 6/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit
import Stevia

class CardView: UIView {
	var isAnswerCard = false

	var frontLabel = UILabel()
	var soundButton = UIButton()

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		render()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv(
			frontLabel.style(labelStyle),
			soundButton.style(buttonStyle)
		)
		frontLabel.centerInContainer()
		soundButton.centerHorizontally()

		layout((>=8),
					 |-(>=8)-soundButton-(>=8)-|,
					 8)
	}

	private func labelStyle(lbl: UILabel) {
		lbl.textAlignment = .center
		lbl.numberOfLines = 0 // Unlimited lines
		lbl.font = lbl.font.withSize(28)
		lbl.textColor = .white
	}

	private func buttonStyle(btn: UIButton) {
		btn.height(44)
		btn.width(44)
		let image = UIImage(named: "Speaker")
		btn.setImage(image, for: .normal)
		btn.addTarget(self, action: #selector(onSoundButton(_:)), for: .touchUpInside)
	}

	@objc func onSoundButton(_ sender: Any) {
		print("Sound Button Tapped!")

		guard let message = frontLabel.text else { return }
		let defaults = UserDefaults.standard

		let rate = defaults.float(forKey: "speechRate")

		let speechSynth = SpeechSynthesizer(rate: rate)

		let locale: String
		switch isAnswerCard {
		case false:
			locale = defaults.string(forKey: "frontCardLanguageCode") ?? detectedLangauge(message) ?? "en-GB"
		case true:
			locale = defaults.string(forKey: "backCardLanguageCode") ?? detectedLangauge(message) ?? "en-GB"
		}

		speechSynth.speak(sentence: message, language: locale)

	}

}



