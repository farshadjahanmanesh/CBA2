//
//  ImageCacher.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/21/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import UIKit

protocol ImageCaching {
	func add(key: String, image: UIImage)
	func remove(key: String)
	func load(key: String)->UIImage?
}
class ImageCacher: ImageCaching {
	private lazy var cache = NSCache<NSString,UIImage>()
	static let shared: ImageCacher = .init()
	
	private init() {
		NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: self, queue: nil, using: {[weak self] notification in
			self?.cache.removeAllObjects()
		})
	}
	
	func add(key: String, image: UIImage) {
		self.cache.setObject(image, forKey: NSString(string: key))
	}
	
	func remove(key: String) {
		self.cache.removeObject(forKey: NSString(string: key))
	}
	
	func load(key: String) -> UIImage? {
		self.cache.object(forKey: NSString(string: key))
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}
