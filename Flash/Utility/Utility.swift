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

extension FileManager {
	public func urlFor(filePath: String, in directory: FileManager.SearchPathDirectory = .documentDirectory, domain: FileManager.SearchPathDomainMask = .userDomainMask) -> URL?  {
		guard let directory = FileManager.default.urls(for: directory, in: domain).first else { return nil }
		return directory.appendingPathComponent(filePath)
	}
}


extension String {

	func getText(between startString: String, and endString: String) -> String? {
		if var startIndex = self.index(of: startString) {

			let newSearchString = String(self[startIndex...])
			startIndex = newSearchString.startIndex
			
			if var endIndex = newSearchString.index(of: endString) {
				endIndex = newSearchString.index(endIndex, offsetBy: -endString.count)
				let range = startIndex..<endIndex
				return String(newSearchString[range])
			} else {
				return nil
			}
		}
		return nil
	}

	func index(of substring: String) -> String.Index? {
		var index = 0

		guard self.contains(substring) else {
			print("\(substring) not found.")
			return nil
		}

		for char in self {
			if substring.first == char {
				let startOfFoundCharacter = self.index(self.startIndex, offsetBy: index)
				let lengthOfFoundCharacter = self.index(self.startIndex, offsetBy: (substring.count + index))
				let range = startOfFoundCharacter..<lengthOfFoundCharacter

				if String(self[range]) == substring {
					print("Found: \(substring)")
					return lengthOfFoundCharacter
				}
			}
			index += 1
		}
		return nil
	}
}

func detectedLangauge<T: StringProtocol>(_ forString: T) -> String? {
	return NSLinguisticTagger.dominantLanguage(for: String(forString)) //else {
//		return nil
//	}
//
//	let detectedLangauge = Locale.current.localizedString(forIdentifier: languageCode)
//
//	return detectedLangauge
}
