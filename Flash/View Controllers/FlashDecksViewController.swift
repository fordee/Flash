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

	//var collection = Collection()

	var accessoryRowSelected: Int? = nil

	//var decks: [Deck] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Flash Decks"
	}

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		switch segue.identifier {
		case "DeckShow":
			if let vc = segue.destination as? FlashDeckDetailViewController {
				if let path = decksTableView.indexPathForSelectedRow {
					vc.navigationItem.title = Database.collection.decks[path.row].title
					vc.deck = Database.collection.decks[path.row]
					vc.cards = Database.collection.decks[path.row].cards
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
				vc.deck = Database.collection.decks[path.row]
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
				vc.navigationItem.title = Database.collection.decks[path.row].title
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
			Database.collection.decks.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
	{
		let closeAction = UIContextualAction(style: .normal, title:  "Close") { action, view, success in
			print("Selected deck: \(Database.collection.decks[indexPath.row].title)")
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
		return Database.collection.decks.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell", for: indexPath) as! DeckCell
		cell.render(with: Database.collection.decks[indexPath.row])
		cell.selectionStyle = .none
		return cell
	}

	func tableView(_ tableView: UITableView,	accessoryButtonTappedForRowWith indexPath: IndexPath) {
		print("Accessory row: \(indexPath.row)")
		accessoryRowSelected = indexPath.row
	}

}

protocol FlashDecksViewControllerDelegate: AnyObject {
	func add(deck: Deck)
	func update(deck: Deck)
	func update(cards: [Card])
}

extension FlashDecksViewController: FlashDecksViewControllerDelegate {
	func add(deck: Deck) {
		Database.collection.decks.append(deck)
		deck.addDeck()
		//collection.save()
		decksTableView.reloadData()
	}

	func update(deck: Deck) {
		if let path = decksTableView.indexPathForSelectedRow {
			Database.collection.decks[path.row] = deck
		} else if let row = accessoryRowSelected {
			Database.collection.decks[row] = deck
			accessoryRowSelected = nil
		} else {
			print("No row selected")
		}
		//collection.save()
		decksTableView.reloadData()
	}

	func update(cards: [Card]) {
		if let path = decksTableView.indexPathForSelectedRow {
			Database.collection.decks[path.row].cards = cards
		} else {
			print("No row selected")
		}
	}
}

extension Notification.Name {
	static let refreshSelectedDeck = Notification.Name("refreshSelectedDeck")
}

