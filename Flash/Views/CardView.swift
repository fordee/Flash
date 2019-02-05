//
//  CardView.swift
//  Flash
//
//  Created by John Forde on 6/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit
import Stevia

class CardView: UIView {
	var isAnswerCard = false

	var frontLabel = UILabel()

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		render()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv(
			frontLabel.style(labelStyle)
		)
		frontLabel.centerInContainer()
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.font = lbl.font.withSize(28)
		lbl.textColor = .white
	}

}



