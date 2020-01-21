//
//  CurrentBookCollectionReusableView.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/18/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import UIKit

class CurrentBookCollectionReusableView: UICollectionReusableView, ModelFillable {
	typealias Model = BookModel
	
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var coverImageView: UIImageView!
	@IBOutlet private var authorLabel: UILabel!
	@IBOutlet private var otherInfoLabel: UILabel!
	
	override func layoutSubviews() {
		super.layoutSubviews()
		coverImageView.superview!.dropShadow(color: .black, offSet: .init(width: 1, height: 1))
	}
	
	func fill(_ model: BookModel) {
		self.setNeedsLayout()
		self.layoutIfNeeded()
		titleLabel.text = model.name
		if let image = model.coverAddress
		{
			coverImageView.fromDisk(image)
		}
		authorLabel.text = model.author
		otherInfoLabel.text = model.otherInfo
	}
}
extension URL {
	static var documentsDirectory: URL {
		let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
		return URL(string:documentsDirectory)!
	}
	
	static func urlInDocumentsDirectory(with filename: String) -> URL {
		return documentsDirectory.appendingPathComponent(filename)
	}
}
