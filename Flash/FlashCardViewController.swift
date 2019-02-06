//
//  ViewController.swift
//  Flash
//
//  Created by John Forde on 2/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

enum DifficultyRank: String {
	case easy
	case medium
	case hard
	case fail
}


class FlashCardViewController: UIViewController {

	let throwingThreshold: CGFloat = 1000
	let throwingVelocityPadding: CGFloat = 10

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
		flashCardView.render(with: deck.currentCard)
		setupNextUpView()
		nextUpView.render(with: deck.nextCard())

		view.addSubview(nextUpView)
		view.addSubview(flashCardView)
	}

	private func setupFlashCardView() {
		flashCardView = CardView(frame: CGRect(x: 42, y: 53, width: 295, height: 509))
		flashCardView.layer.cornerRadius = 20

		let panGR = UIPanGestureRecognizer(target: self, action: #selector(handleAttachmentGesture(sender:)))
		flashCardView.addGestureRecognizer(panGR)

		let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		flashCardView.addGestureRecognizer(tapGR)

		animator = UIDynamicAnimator(referenceView: view)
		originalBounds = flashCardView.bounds
		originalCenter = flashCardView.center
	}

	private func setupNextUpView() {
		nextUpView = CardView(frame: CGRect(x: 42, y: 53, width: 295, height: 509))
		nextUpView.isUserInteractionEnabled = false
		nextUpView.layer.cornerRadius = 20
		nextUpView.transform = CGAffineTransform(scaleX: minScale, y: minScale)
	}

	@objc func handleTap(sender: Any) {
		let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

		UIView.transition(with: flashCardView, duration: 1.0, options: transitionOptions, animations: {
			self.flashCardView.isAnswerCard.toggle()
			let currentCard =  self.deck.previousCard // Because we have skipped ahead for next card view
			self.flashCardView.render(with: currentCard)
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

			let angle = atan2(velocity.y, velocity.x) * 180.0 / CGFloat.pi
			let difficulty = getDifficultyRank(from: angle).rawValue
			print("Difficulty: \(difficulty)")

			if magnitude > throwingThreshold {
				let pushBehavior = UIPushBehavior(items: [flashCardView], mode: .instantaneous)
				pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
				pushBehavior.magnitude = magnitude / throwingVelocityPadding

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

	private func addNewCard() {
		// Remove old cards
		flashCardView.removeFromSuperview()
		nextUpView.removeFromSuperview()

		// Setup new cards
		setupFlashCardView()
		flashCardView.render(with: deck.currentCard)
		setupNextUpView()
		nextUpView.render(with: deck.nextCard())

		view.addSubview(nextUpView)
		view.addSubview(flashCardView)
	}

	private func returnCardToDeck() {
		animator.removeAllBehaviors()

		UIView.animate(withDuration: 0.45) {
			self.flashCardView.bounds = self.originalBounds
			self.flashCardView.center = self.originalCenter
			self.flashCardView.transform = CGAffineTransform.identity
		}
	}

	private func getDifficultyRank(from angle: CGFloat) -> DifficultyRank {
		// convert to 360 degrees
		let angle360: CGFloat
		if angle < 0 {
			angle360 = 180 + (180 - abs(angle))
		} else {
			angle360 = angle
		}
		// Add 45 degree offset to match pattern matching easier
		let offsetAngle = angle360 + 45

		switch offsetAngle {
		case 0..<90:
			return .hard
		case 90..<180:
			return .fail
		case 180..<270:
			return .easy
		case 270..<360:
			return .medium
		case 360...405:
			return .hard
		default:
			return .fail
		}
	}

}

