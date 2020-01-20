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
	
	@IBOutlet private var coverSelectorImage: UIImageView!
	@IBOutlet private var authorLabel: UILabel!
	@IBOutlet private var pageCountLabel: UILabel!
	@IBOutlet private var readingSoFarLabel: UILabel!
	@IBOutlet private var otherInfoTextView: UITextView!
	@IBOutlet private var readingButton: UIButton!
	@IBOutlet private var scrollView: UIScrollView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		styles()
		bind()
	}
	private func bind() {
		self.viewModel.readingTime.listen { value in
			print(value)
		}
		
		self.viewModel.isReading.listen {[weak self] isReading in
			self?.updateReadingButtonTitle(isReading)
		}
		
		self.viewModel.readingTime.listen {[weak self] number in
			guard let self = self else {return}
			let seconds = Int(self.viewModel.book.totalReadSeconds) + number
			self.readingSoFarLabel.text = "Reading So Far(seconds): \(seconds)"
		}
	}
	private func styles() {
		self.navigationItem.title = viewModel.book.name
		coverSelectorImage.fromDisk(viewModel.book.coverAddress ?? "")
		authorLabel.text = "Author/s: \(viewModel.book.author ?? "")"
		pageCountLabel.text = "Author/s: \(viewModel.book.numberOfPages)"
		otherInfoTextView.text = viewModel.book.otherInfo ?? ""
		if !self.viewModel.isReading.value {
			readingSoFarLabel.text = "Reading So Far(seconds): \(Int64(viewModel.book.totalReadSeconds))"
		}
		updateReadingButtonTitle(self.viewModel.isReading.value)
		coverSelectorImage.superview!.dropShadow(color: .black, offSet: .init(width: 1, height: 1))
		readingButton.addTarget(self, action: #selector(self.toggleReading), for: .touchUpInside)
	}
	private func updateReadingButtonTitle(_ isReading: Bool) {
		self.readingButton.setTitle(isReading ? "Stop Reading" : "Start Reading", for: .normal)
	}
	@objc
	private func toggleReading() {
		if self.viewModel.isReading.value {
			self.viewModel.stopReading()
		} else {
			self.viewModel.startReading()
		}
	}
}
