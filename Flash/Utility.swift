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

//extension UIView
//{
//	func copyView<T: UIView>() -> T {
//		//return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
//		return NSKeyedArchiver.unarc
//	}
//}

extension NSObject {
	func copyObject<T:NSObject>() throws -> T? {
		let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
		return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
	}
}
