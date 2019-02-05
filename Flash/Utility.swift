//
//  Utility.swift
//  Flash
//
//  Created by John Forde on 5/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

extension CGPoint {
	func distance(from: CGPoint) -> CGFloat {
		let xDelta = abs(self.x - from.x)
		let yDelta = abs(self.y - from.y)
		let distance = sqrt(xDelta * xDelta + yDelta * yDelta)
		return distance
	}
}

extension UIColor {
	// https://github.com/yeahdongcn/UIColor-Hex-Swift/blob/master/HEXColor/UIColorExtension.swift
	public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
		let divisor = CGFloat(255)
		let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
		let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
		let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}

	var brightness: CGFloat {
		var R: CGFloat = 0
		var G: CGFloat = 0
		var B: CGFloat = 0
		var A: CGFloat = 0
		self.getRed(&R, green: &G, blue: &B, alpha: &A)
		let R_sqr = 0.299 * R
		let G_sqr = 0.587 * G
		let B_sqr = 0.114 * B
		let brightness = sqrt( R_sqr + G_sqr + B_sqr )
		return brightness
	}
}

