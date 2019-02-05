//
//  ViewController.swift
//  Flash
//
//  Created by John Forde on 2/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

class FlashCardViewController: UIViewController {

	let ThrowingThreshold: CGFloat = 1000
	let ThrowingVelocityPadding: CGFloat = 10

	let minScale: CGFloat = 0.8

	private var deck = Deck()

	private var flashCardView: CardView!
	private var nextUpView: CardView!

	private var originalBounds = CGRect.zero
	private var originalCenter = CGPoint.zero

	private var startLocation = CGPoint.zero

	private var animator: UIDynamicAnimator!
	private var attachmentBehavior: UIAttachmentBehavior!
	private var pushBehavior: UIPushBehavior!
	private var itemBehavior: UIDynamicItemBehavior!

	override func viewDidLoad() {
		super.viewDidLoad()

		setupFlashCardView()
		flashCardView.render(with: deck.nextCard())
		setupNextUpView()
		nextUpView.render(with: deck.nextCard())

		view.addSubview(nextUpView)
		view.addSubview(flashCardView)

		let panGR = UIPanGestureRecognizer(target: self, action: #selector(handleAttachmentGesture(sender:)))
		view.addGestureRecognizer(panGR)

	}

	private func setupFlashCardView() {
		// x: 42
		// y: 53
		// width: 295
		// height: 509
		flashCardView = CardView(frame: CGRect(x: 42, y: 53, width: 295, height: 509))
		flashCardView.layer.cornerRadius = 20

		let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		flashCardView.addGestureRecognizer(tapGR)

		animator = UIDynamicAnimator(referenceView: view)
		originalBounds = flashCardView.bounds
		originalCenter = flashCardView.center
	}

	private func setupNextUpView() {
		// x: 42
		// y: 53
		// width: 295
		// height: 509
		nextUpView = CardView(frame: CGRect(x: 42, y: 53, width: 295, height: 509))
		nextUpView.isUserInteractionEnabled = false
		nextUpView.layer.cornerRadius = 20
		nextUpView.transform = CGAffineTransform(scaleX: minScale, y: minScale)
	}

	@objc func handleTap(sender: Any) {
		print("Tapped...")
		let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

		UIView.transition(with: flashCardView, duration: 1.0, options: transitionOptions, animations: {
			self.flashCardView.isAnswerCard.toggle()
			let currentCard =  self.deck.currentCard
			self.flashCardView.frontLabel.text = self.flashCardView.isAnswerCard ? currentCard.backWord : currentCard.frontWord // TODO: This should be handled in the render function.
		})
	}

	@objc func handleAttachmentGesture(sender: UIPanGestureRecognizer) {
		let location = sender.location(in: self.view)
		let boxLocation = sender.location(in: self.flashCardView)

		switch sender.state {
		case .began:
			animator.removeAllBehaviors()

			startLocation = location

			let centerOffset = UIOffset(horizontal: boxLocation.x - flashCardView.bounds.midX,
																	vertical: boxLocation.y - flashCardView.bounds.midY)

			attachmentBehavior = UIAttachmentBehavior(item: flashCardView, offsetFromCenter: centerOffset, attachedToAnchor: location)
			animator.addBehavior(attachmentBehavior)

		case .ended:
			animator.removeAllBehaviors()

			let velocity = sender.velocity(in: view)
			let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))

			if magnitude > ThrowingThreshold {
				let pushBehavior = UIPushBehavior(items: [flashCardView], mode: .instantaneous)
				pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
				pushBehavior.magnitude = magnitude / ThrowingVelocityPadding

				self.pushBehavior = pushBehavior
				animator.addBehavior(pushBehavior)

				//let angle = Int.random(in: 1...5) //(arc4random_uniform(20)) - 10

				itemBehavior = UIDynamicItemBehavior(items: [flashCardView])
				itemBehavior.friction = 0.2
				itemBehavior.allowsRotation = true
				//itemBehavior.addAngularVelocity(CGFloat(angle), for: flashCardView)
				animator.addBehavior(itemBehavior)


				//let distance = location.distance(from: startLocation)
				//print("distance = \(distance), velocity = \(magnitude)")
				UIView.animate(withDuration: 0.6) {
					self.nextUpView.transform = CGAffineTransform.identity
				}

				// Before we reset, we need to stop interaction before we can swap out the cards
				flashCardView.isUserInteractionEnabled = false

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
					self.addNewCard()
				}

			} else {
				returnCardToDeck()
			}

		default:
			attachmentBehavior.anchorPoint = location
			let distance = location.distance(from: startLocation)
			//print("distance = \(distance)")
			//let ratio = (((1.0 - (abs(distance - 200) / 200)) / 5.0) + minScale)

			let res1 = distance > 200 ? 0 : abs(distance - 200)
			let res2 = res1 / 200
			let res3 = 1.0 - res2
			let res4 = res3 / 5.0
			let res5 = res4 + minScale
			let ratio = min(1, res5)

			//print("ratio = \(ratio)")
			nextUpView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
		}
	}

	func addNewCard() {
		// Remove old cards
		flashCardView.removeFromSuperview()
		nextUpView.removeFromSuperview()

		// Setup new cards
		setupFlashCardView()
		flashCardView.render(with: deck.previousCard)
		setupNextUpView()
		nextUpView.render(with: deck.nextCard())

		view.addSubview(nextUpView)
		view.addSubview(flashCardView)
	}

	func returnCardToDeck() {
		animator.removeAllBehaviors()

		UIView.animate(withDuration: 0.45) {
			self.flashCardView.bounds = self.originalBounds
			self.flashCardView.center = self.originalCenter
			self.flashCardView.transform = CGAffineTransform.identity
		}
	}


}

