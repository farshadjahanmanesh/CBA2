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
	func fill(_ model: BookModel) {
		titleLabel.text = model.name
		if let image = model.coverAddress
		{
			coverImageView.fromDisk(image)
		}
		authorLabel.text = model.author
	}
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var coverImageView: UIImageView!
	@IBOutlet var authorLabel: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
}
