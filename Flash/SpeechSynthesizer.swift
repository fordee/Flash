//
//  speechSynthesizer.swift
//  Flash
//
//  Created by John Forde on 27/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechSynthesizer {

	private let synthesizer: AVSpeechSynthesizer
	private let rate: Float

	init(rate: Float = 0.3) {
		self.rate = rate
		self.synthesizer = AVSpeechSynthesizer()
	}

	func speak(sentence: String, language: String = "en-GB") {
		let utterance = AVSpeechUtterance(string: sentence)
		utterance.voice = AVSpeechSynthesisVoice(language: language)
		utterance.rate = rate
		synthesizer.speak(utterance)
	}
}
