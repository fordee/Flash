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

	var collection = Collection()

	//var decks: [Deck] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		setupDecks()
		title = "Flash Decks"

		//let sampleDeck = Deck(deckFileName: "JLPT2Vocab.csv")
		//collection.decks.append(sampleDeck)
		//let sampleDeck = Deck(deckFileName: "test.csv")
	}

	func setupDecks() {
		//Deck.setupDeckTable()
		//decks.append(Deck(title: "1500 Most Used Kanji"))
		//decks.append(Deck(title: "Japanese Vocabulary Deck"))
		//decks.append(Deck(title: "Hiragana"))
	}



	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		switch segue.identifier {
		case "DeckShow":
			if let vc = segue.destination as? FlashDeckDetailViewController {
				if let path = decksTableView.indexPathForSelectedRow {
					vc.navigationItem.title = collection.decks[path.row].title
					vc.cards = collection.decks[path.row].cards
					vc.delegate = self
				}
			}
		case "NewDeck":
			if let vc = segue.destination as? AddDeckViewController {
				vc.delegate = self
				vc.isAdd = true
			}

		default:
			fatalError("Unknown segue.identifier: \(segue.identifier ?? "")")
		}


		if segue.identifier == "DeckShow" {
			let vc = segue.destination
			if let path = decksTableView.indexPathForSelectedRow {
				vc.navigationItem.title = collection.decks[path.row].title
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
			collection.decks.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return collection.decks.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell", for: indexPath) as! DeckCell
		cell.render(with: collection.decks[indexPath.row])
		cell.selectionStyle = .none
		return cell
	}


}

protocol FlashDecksViewControllerDelegate: AnyObject {
	func add(deck: Deck)
	func update(deck: Deck)
	func update(cards: [Card])
}

extension FlashDecksViewController: FlashDecksViewControllerDelegate {
	func add(deck: Deck) {
		collection.decks.append(deck)
		collection.save()
		decksTableView.reloadData()
	}

	func update(deck: Deck) {
		if let path = decksTableView.indexPathForSelectedRow {
			collection.decks[path.row] = deck
			collection.save()
			decksTableView.reloadData()
		} else {
			print("No row selected")
		}
	}

	func update(cards: [Card]) {
		if let path = decksTableView.indexPathForSelectedRow {
			collection.decks[path.row].cards = cards
			collection.save()
		} else {
			print("No row selected")
		}
	}
}
