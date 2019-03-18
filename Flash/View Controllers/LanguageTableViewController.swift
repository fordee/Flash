//
//  LanguageTableViewController.swift
//  Flash
//
//  Created by John Forde on 5/03/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

class LanguageTableViewController: UITableViewController {

	var side: Side?
	weak var delegate: LanguageTableViewControllerDelegate?
	
	var languages: [(String, String?)] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		languages = getLanguages()

	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return languages.count
	}

	private func getLanguages() -> [(String, String?)] {
		let languageCodes = Locale.isoLanguageCodes
		return languageCodes.map {
			return ($0, Locale.current.localizedString(forIdentifier: $0))
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
		cell.textLabel?.text = languages[indexPath.row].1 ?? languages[indexPath.row].0
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let side = side else { return }
		let languageCode = languages[indexPath.row].0
		let languageDescription = languages[indexPath.row].1 ?? languageCode

		delegate?.setLanguage(side: side, languageCode: languageCode, languageDescription: languageDescription)

		navigationController?.popViewController(animated: true)
	}

}
