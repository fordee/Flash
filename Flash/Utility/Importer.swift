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
	//let currentWorkingPath: String

	init () {
		fileManager = FileManager()
		//currentWorkingPath = fileManager.currentDirectoryPath
	}

	func importAnki(filename: String) {

		let sourceURL = FileManager.default.urlFor(filePath: filename)!

		do {

			let tmp = try TemporaryFile(creatingTempDirectoryForFilename: "tempfile")

			try fileManager.unzipItem(at: sourceURL, to: tmp.directoryURL)

			defer {
				try? tmp.deleteDirectory()
			}

			guard let ankiFilename = getAnkiFilename(in: tmp.directoryURL) else { return }

			let ankiFilepath = tmp.directoryURL.appendingPathComponent(ankiFilename, isDirectory: false)

			print("AnkiFilepath: \(ankiFilepath)")


		} catch {
			print("Extraction of ZIP archive failed with error:\(error)")
		}
	}

	private func getAnkiFilename(in url: URL) -> String? {
		do {
			let files = try fileManager.contentsOfDirectory(atPath: url.path)
			for file in files {
				if (file as NSString).pathExtension == "anki2" {
					return file
				}
			}
		} catch {
			print("Error: \(error.localizedDescription)")
			return nil
		}
		return nil
	}

}
