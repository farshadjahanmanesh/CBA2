//
//  UIImage+Ext.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/18/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import UIKit
extension UIImage {
    enum jpegQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

	func saveToDisk(quality: jpegQuality, directory: DirectoryPath = .user, name: String? = nil) throws -> String? {
		// choose a name for your image
		let fileName = name ?? "\(UUID().uuidString).png"
		// create the destination file url to save your image
		let fileURL = directory.url.appendingPathComponent(fileName)
		// get your UIImage jpeg data representation and check if the destination file url already exists
		if let data = self.jpegData(compressionQuality:  quality.rawValue),
			!FileManager.default.fileExists(atPath: fileURL.path) {
			try  data.write(to: fileURL)
		}
		return fileName
	}
}
