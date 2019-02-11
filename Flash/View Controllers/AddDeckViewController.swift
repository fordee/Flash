//
//  AddDeckViewController.swift
//  Flash
//
//  Created by John Forde on 9/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

class AddDeckViewController: UIViewController {

	@IBOutlet weak var titleTextField: UITextField!

	@IBAction func onCancelBarButton(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}

	@IBAction func onSaveBarButton(_ sender: Any) {
		print("Save")
		guard let isAdd = isAdd else { fatalError("isAdd is not set") }
		let deck = Deck(title: titleTextField.text ?? "")
		if isAdd {
			delegate?.add(deck: deck)
		} else {
			delegate?.update(deck: deck)
		}
		navigationController?.popViewController(animated: true)
	}


	var deck: Deck?
	var isAdd: Bool?
	weak var delegate: FlashDecksViewControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()

	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
