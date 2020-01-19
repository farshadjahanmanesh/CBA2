//
//  ImageView+Ext.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/23/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import UIKit
// this property have used to indicates if this image's download is finished or not
private var AssociatedObjectHandle: UInt8 = 0
extension UIImageView {
	private var urlToLoad:URL? {
		get {
			return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? URL
		}
		set {
			objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	/// load an image from a url(or cache). every image will be cached by system after it download is finished.
	/// - Parameters:
	///   - string: url string
	///   - done: a callback that will call after image is ready
	func fromDisk(_ named: String, done: ((UIImage?)->Void)? = nil, directory: DirectoryPath = .user) {
		let imageURL = URL(fileURLWithPath: directory.url.path).appendingPathComponent(named)
		urlToLoad = imageURL
		if let cachedImage = ImageCacher.shared.load(key: imageURL.path){
			DispatchQueue.main.async {[weak self] in
				let image = cachedImage
				self?.image = image
				done?(image)
			}
		} else {
			guard let image =  UIImage(contentsOfFile: imageURL.path) else {return}
			ImageCacher.shared.add(key: imageURL.path, image: image)
			DispatchQueue.main.async {[weak self] in
				guard let self = self else {return}
				if self.urlToLoad == imageURL {
					self.image = image
				}
			}
			return
		}
	}
	
}
