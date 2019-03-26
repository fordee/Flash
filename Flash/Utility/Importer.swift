//
//  Importer.swift
//  Flash
//
//  Created by John Forde on 26/03/19.
//  Copyright © 2019 4DWare. All rights reserved.
//

import Foundation
import ZIPFoundation

class Importer {

	let fileManager: FileManager
	let currentWorkingPath: String

	init () {
		fileManager = FileManager()
		currentWorkingPath = fileManager.currentDirectoryPath
	}

	func importAnki(filename: String) {

		let sourceURL = FileManager.default.urlFor(filePath: filename)!

		do {

			let tmp = try TemporaryFile(creatingTempDirectoryForFilename: "tempfile")

			//try fileManager.createDirectory(at: destinationDirectory, withIntermediateDirectories: true, attributes: nil)
			try fileManager.unzipItem(at: sourceURL, to: tmp.fileURL)
		} catch {
			print("Extraction of ZIP archive failed with error:\(error)")
		}
	}

}
