//
//  SettingsViewController.swift
//  Flash
//
//  Created by John Forde on 6/03/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

enum Side {
	case front
	case back
}

class SettingsTableViewController: UITableViewController {

	@IBOutlet weak var frontLanguageLabel: UILabel!
	@IBOutlet weak var backLanguageLabel: UILabel!

	@IBAction func onValueChanged(_ sender: Any) {
		let rate = (sender as! UISlider).value
		print("Value changed: \(rate)")
		let synth = SpeechSynthesizer(rate: rate)
		synth.speak(sentence: "Testing")
		UserDefaults.standard.set(rate, forKey: "speechRate")
	}


	override func viewDidLoad() {
		super.viewDidLoad()
		setLanguageLabels()
	}

	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		if segue.identifier == "FrontCardSegue" || segue.identifier == "BackCardSegue" {
			if let vc = segue.destination as? LanguageTableViewController {
				vc.delegate = self
				switch segue.identifier {
				case "FrontCardSegue":
					vc.side = .front
				case "BackCardSegue":
					vc.side = .back
				default:
					fatalError("Unexpected case in segue: \(segue.identifier!)")
				}
			}
		}
	}

	private func setLanguageLabels() {
		let defaults = UserDefaults.standard
		frontLanguageLabel.text = defaults.string(forKey: "frontCardLanguageDescription") ?? "None"
		backLanguageLabel.text = defaults.string(forKey: "backCardLanguageDescription") ?? "None"
	}

}

protocol LanguageTableViewControllerDelegate: AnyObject {
	func setLanguage(side: Side, languageCode: String, languageDescription: String)
}

extension SettingsTableViewController: LanguageTableViewControllerDelegate {

	func setLanguage(side: Side, languageCode: String, languageDescription: String) {
		print("languageCode: \(languageCode)")
		switch side {
		case .front:
			UserDefaults.standard.set(languageCode, forKey: "frontCardLanguageCode")
			UserDefaults.standard.set(languageDescription, forKey: "frontCardLanguageDescription")
			frontLanguageLabel.text = languageDescription
		case .back:
			UserDefaults.standard.set(languageCode, forKey: "backCardLanguageCode")
			UserDefaults.standard.set(languageDescription, forKey: "backCardLanguageDescription")
			backLanguageLabel.text = languageDescription
		}
	}

}
