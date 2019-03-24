//
//  Color.swift
//  Flash
//
//  Created by John Forde on 28/02/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import UIKit

// Use my own type for color because UIColor can't be Codable
struct Color: Equatable, Hashable, Codable {
	var color: String = ""

	var uiColor: UIColor {
		return hexStringToColor(hexString: color)
	}

	static func random() -> Color {
		let color =  UIColor(red:   CGFloat.random(in: 0...1),
												 green: CGFloat.random(in: 0...1),
												 blue:  CGFloat.random(in: 0...1), alpha: 1)
		return Color(color: color)
	}

	public func uiColorToString(color: UIColor) -> String {
		var red: CGFloat = 0.0; var green: CGFloat = 0.0; var blue: CGFloat = 0.0; var alpha: CGFloat = 0.0
		color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		return hexToString(red: red, green: green, blue: blue)
	}

	public func hexToString(red r: CGFloat, green g: CGFloat, blue b: CGFloat) -> String {
		let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
		return NSString(format:"#%06x", rgb) as String
	}

	func hexStringToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
		// Convert hex string to an integer
		let hexint = Int(intFromHexString(hexStr: hexString))
		let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
		let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
		let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
		let alpha = alpha!
		// Create color object, specifying alpha as well
		let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
		return color
	}

	func intFromHexString(hexStr: String) -> UInt32 {
		var hexInt: UInt32 = 0
		let scanner: Scanner = Scanner(string: hexStr)
		scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
		scanner.scanHexInt32(&hexInt)
		return hexInt
	}

	init(color: UIColor) {
		self.color = uiColorToString(color: color)
	}

	init(hexString: String) {
		self.color = hexString
	}

}

