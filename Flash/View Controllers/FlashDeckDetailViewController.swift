//
//  FalshDeckDetailViewController.swift
//  Flash
//
//  Created by John Forde on 9/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

class FlashDeckDetailViewController: UIViewController {

	@IBOutlet weak var cardsTableView: UITableView!

	var cards: [Card] = []
	weak var delegate: FlashDecksViewControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()

//		let deck = Deck(title: "Test Deck")
//		cards = deck.cards

	}



	// MARK: - Navigation


	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if self.isMovingFromParent {
			print("Back pressed.")
			delegate?.update(cards: cards)
		}
	}

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
		switch segue.identifier {
		case "NewCard":
			guard let vc = segue.destination as? AddCardViewController else { return }
			vc.navigationItem.title = "Add Card"
			vc.delegate = self
			vc.isAdd = true
		case "EditCard":
			guard let vc = segue.destination as? AddCardViewController else { return }
			vc.navigationItem.title = "Edit Card"
			vc.delegate = self
			vc.isAdd = false
			if let path = cardsTableView.indexPathForSelectedRow {
				vc.card = cards[path.row]
			}
		default:
			fatalError("Unkown segue.identifier")
		}
	}

}

extension FlashDeckDetailViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCell.EditingStyle.delete {
			cards.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cards.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
		cell.render(with: cards[indexPath.row])
		cell.selectionStyle = .none
		return cell
	}


}

protocol FlashDeckDetailViewControllerDelegate: AnyObject {
	func add(card: Card)
	func update(card: Card)
}

extension FlashDeckDetailViewController: FlashDeckDetailViewControllerDelegate {

	func add(card: Card) {
		cards.append(card)
		cardsTableView.reloadData()
	}

	func update(card: Card) {
		if let path = cardsTableView.indexPathForSelectedRow {
			cards[path.row] = card
			cardsTableView.reloadData()
		} else {
			print("No row selected")
		}

	}


}
