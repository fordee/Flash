//
//  DeckCell.swift
//  Flash
//
//  Created by John Forde on 8/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

class DeckCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var numberOfCardsLabel: UILabel!

	

	func render(with deck: Deck) {
		titleLabel.text = deck.title
		numberOfCardsLabel.text = "\(deck.cards.count) Cards"
		if deck.isSelected {
			backgroundColor = .cyan
		} else {
			backgroundColor = .white
		}
	}



	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
	}

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
