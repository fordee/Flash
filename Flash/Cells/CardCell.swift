//
//  CardCell.swift
//  Flash
//
//  Created by John Forde on 9/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

	@IBOutlet weak var frontLabel: UILabel!
	@IBOutlet weak var backLabel: UILabel!

	func render(with card: Card) {
		frontLabel.text = card.frontWord
		backLabel.text = card.backWord
		
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
