//
//  BookCollectionViewCell.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/18/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell, ModelFillable {
	typealias Model = BookModel
	
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var coverImageView: UIImageView!
	@IBOutlet private var authorLabel: UILabel!
	@IBOutlet private var readingTimeLabel: UILabel!
	
	func fill(_ model: BookModel) {
		titleLabel.text = model.name
		if let image = model.coverAddress
		{
			coverImageView.fromDisk(image)
		}
		authorLabel.text = model.author
		readingTimeLabel.text = "is read: \(Int(model.totalReadSeconds)) (s)"
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
}
