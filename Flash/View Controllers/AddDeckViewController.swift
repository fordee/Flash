//
//  AddDeckViewController.swift
//  Flash
//
//  Created by John Forde on 9/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

class AddDeckViewController: UITableViewController {

	var deck: Deck?
	var isAdd: Bool?
	var isGoingForward = false

	@IBOutlet weak var frontLanguageLabel: UILabel!
	@IBOutlet weak var backLanguageLabel: UILabel!
	
	@IBOutlet weak var titleTextField: UITextField!

	override func viewWillAppear(_ animated: Bool) {
		isGoingForward = false
	}

	override func viewWillDisappear(_ animated: Bool) {
		if !isGoingForward {
			save()
		}
	}

	weak var delegate: FlashDecksViewControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard let isAdd = isAdd else { return }

		if isAdd {
			// Create empty deck
			deck = Deck(title: "New Deck")
			
			title = "New Deck"
		} else {
			title = "Edit Deck"
		}


		guard let deck = deck else { return }
		if !isAdd { titleTextField.text = deck.title }

		if let frontLanguage = deck.frontLanguage {
			frontLanguageLabel.text = Locale.current.localizedString(forIdentifier: frontLanguage)
		}

		if let backLanguage = deck.backLanguage {
			backLanguageLabel.text = Locale.current.localizedString(forIdentifier: backLanguage)
		}

	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		isGoingForward = true
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

	private func save() {
		print("Save")
		guard let isAdd = isAdd else { fatalError("isAdd is not set") }
		deck?.title = titleTextField.text ?? ""

		guard let deck = deck else { return	}

		if isAdd {
			delegate?.add(deck: deck)
			deck.addDeck()
		} else {
			delegate?.update(deck: deck)
			deck.updateDeck()
		}
	}

}

extension AddDeckViewController: LanguageTableViewControllerDelegate {

	func setLanguage(side: Side, languageCode: String, languageDescription: String) {
		print("languageCode: \(languageCode)")
		switch side {
		case .front:
			deck?.frontLanguage = languageCode
			frontLanguageLabel.text = languageDescription
		case .back:
			deck?.backLanguage = languageCode
			backLanguageLabel.text = languageDescription
		}
	}

}

