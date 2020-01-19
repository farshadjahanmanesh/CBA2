//
//  BookDetailsViewController.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/20/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController, ViewModelHolder {
	var viewModel: BookDetailsViewModel!
	
	@IBOutlet var coverSelectorImage: UIImageView!
	@IBOutlet var authorLabel: UILabel!
	@IBOutlet var pageCountLabel: UILabel!
	@IBOutlet var otherInfoTextView: UITextView!
	@IBOutlet var readingButton: UIButton!
	@IBOutlet var scrollView: UIScrollView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		styles()
	}
	
	private func styles() {
		self.navigationItem.title = viewModel.book.name
		coverSelectorImage.fromDisk(viewModel.book.coverAddress ?? "")
		authorLabel.text = "Author/s: \(viewModel.book.author ?? "")"
		pageCountLabel.text = "Author/s: \(viewModel.book.numberOfPages)"
		otherInfoTextView.text = viewModel.book.otherInfo ?? ""
		coverSelectorImage.dropShadow(color: .black, offSet: .init(width: 1, height: 1))
	}
}
