//
//  FlashDecksViewController.swift
//  Flash
//
//  Created by John Forde on 8/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit


class FlashDecksViewController: UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var decksTableView: UITableView!


	@IBAction func onSelectSegmentedControl(_ sender: Any) {
		
	}

	var accessoryRowSelected: Int? = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Flash Decks"

	}

	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		switch segue.identifier {
		case "DeckShow":
			if let vc = segue.destination as? FlashDeckDetailViewController {
				if let path = decksTableView.indexPathForSelectedRow {
					vc.navigationItem.title = Database.collection.deck(at: path.row).title
					vc.deck = Database.collection.deck(at: path.row)
					vc.cards = Database.collection.deck(at: path.row).allCards
					vc.delegate = self
				}
			}
		case "NewDeck":
			if let vc = segue.destination as? AddDeckViewController {
				vc.delegate = self
				vc.isAdd = true
			}
		case "EditDeck":
			if let vc = segue.destination as? AddDeckViewController, let cell = (sender as? DeckCell), let path = decksTableView.indexPath(for: cell) {
				vc.deck = Database.collection.deck(at: path.row)
				//vc.deckTitle = text
				vc.delegate = self
				vc.isAdd = false
			}
		default:
			fatalError("Unknown segue.identifier: \(segue.identifier ?? "")")
		}

		if segue.identifier == "DeckShow" {
			let vc = segue.destination
			if let path = decksTableView.indexPathForSelectedRow {
				vc.navigationItem.title = Database.collection.deck(at: path.row).title
			}
		}
	}


}

extension FlashDecksViewController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCell.EditingStyle.delete {
			//let deck = Database.collection.deck(at: indexPath.row)
			//deck.delete() TODO: remove comment
			Database.collection.removeDeck(at: indexPath.row) //decks.remove(at: indexPath.row) // TODO: This should be part of delete function
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
	{
		let closeAction = UIContextualAction(style: .normal, title:  "Close") { action, view, success in
			print("Selected deck: \(Database.collection.deck(at: indexPath.row).title)")
			Database.collection.selectDeck(at: indexPath.row)
			self.decksTableView.reloadData()
			NotificationCenter.default.post(name: .refreshSelectedDeck, object: nil, userInfo: nil)
			success(true)
		}
		closeAction.image = UIImage(named: "Tick")
		closeAction.backgroundColor = .blue

		return UISwipeActionsConfiguration(actions: [closeAction])

	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Database.collection.allDecks.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell", for: indexPath) as! DeckCell
		cell.render(with: Database.collection.deck(at: indexPath.row))
		cell.selectionStyle = .none
		return cell
	}

	func tableView(_ tableView: UITableView,	accessoryButtonTappedForRowWith indexPath: IndexPath) {
		print("Accessory row: \(indexPath.row)")
		accessoryRowSelected = indexPath.row
	}

}

extension FlashDecksViewController: AddDeckViewControllerDelegate {
	func add(deck: Deck) {
		Database.collection.addDeck(deck: deck)
		decksTableView.reloadData()
	}

	func update(deck: Deck) {
		if let path = decksTableView.indexPathForSelectedRow {
			Database.collection.updateDeck(deck, at: path.row)
		} else if let row = accessoryRowSelected {
			Database.collection.updateDeck(deck, at: row)//decks[row] = deck
			accessoryRowSelected = nil
		} else {
			fatalError("No row selected")
		}
		decksTableView.reloadData()
	}

	func update(cards: [Card]) {
		if let path = decksTableView.indexPathForSelectedRow {
			Database.collection.setCards(cards, atDeckIndex: path.row)//deck(at: path.row).setCards(cards)
		} else {
			print("No row selected")
		}
	}
}

extension Notification.Name {
	static let refreshSelectedDeck = Notification.Name("refreshSelectedDeck")
}

