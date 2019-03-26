//
//  AddCardViewController.swift
//  Flash
//
//  Created by John Forde on 9/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController {

	@IBOutlet weak var frontTextView: UITextView!

	@IBOutlet weak var backTextView: UITextView!
	
	@IBAction func onCancelBarButton(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}

	@IBAction func onSaveBarButton(_ sender: Any) {
		print("Save")
		guard let isAdd = isAdd else { fatalError("isAdd is not set") }
		let card = Card(backgroundColor: Color.random()/*.magenta*/, frontWord: frontTextView.text, backWord: backTextView.text)
		if isAdd {
			delegate?.add(card: card)
		} else {
			delegate?.update(card: card)
		}
		navigationController?.popViewController(animated: true)
	}

	var deck: Deck?
	var card: Card?
	var isAdd: Bool?

	weak var delegate: FlashDeckDetailViewControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()

		frontTextView.layer.borderWidth = 1
		frontTextView.layer.borderColor = UIColor.black.cgColor
		frontTextView.layer.cornerRadius = 8

		backTextView.layer.borderWidth = 1
		backTextView.layer.borderColor = UIColor.black.cgColor
		backTextView.layer.cornerRadius = 8

		if card != nil {
			frontTextView.text = card?.frontWord
			backTextView.text = card?.backWord
		} else {
			frontTextView.text = UIPasteboard.general.string
			parseImaWaCopy()
		}
	}

	func parseImaWaCopy() {
		let paste = UIPasteboard.general.string
		guard let pasteString = paste else {
			return
		}

		let onYomi = pasteString.getText(between: "ON reading: ", and: "\n")
		let kunYomi = pasteString.getText(between: "Kun reading: ", and: "\n")
		let kanji = pasteString.getText(between: "Kanji: ", and: "\n")
		let meaning = pasteString.getText(between: "Meaning: ", and: "\n")

		backTextView.text = "\(onYomi ?? "")\n\(kunYomi ?? "")\n\(meaning ?? "")"
		frontTextView.text = kanji
//		if let startIndex = pasteString.index(of: "Reading:\n"),
//			let endIndex = pasteString.index(of: "\nNanori") {
//			print("Start Index: \(startIndex), End Index: \(endIndex)")
//			let range = startIndex..<endIndex
//			print("Range: \(range)")
//			backTextView.text  = String(pasteString[range])
//		}
	}

	

}
